//
//  GridTVVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/11.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//


//Mark: --- 用于商品网格视图数据展示

import UIKit
import SVProgressHUD

 protocol  GridTVVCDelegate {
    func gridTableViewDidScroll(_ scrollView: UIScrollView)
    func gridTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func gridTVVCCellDidClick(btn: UIButton, btnType: GridTVVCCellBtnType, cellIndexPath: IndexPath?)
}


class GridTVVC: UITableViewController {
    
    //Mark: --- 加个小动画
    var _lastIndex:Int?
    
    
    //Mark: --- 标题数据源
    var titleArr = [String]()
    
    //Mark: --- 标题宽度占比
    var titleWidthWeight = [Int]()
    
    //Mark: --- 当前左/右滑动的cell
    var currentSwipeCell:GridTVVCCell?
    
    
    //Mark: --- 数据源
    //var dataSource = [GridTVGoodsModel]()
    var dataSource:[RepGoodsModel]? {
        didSet {
            initialFoldFlagArray()
            initialDetailCellRowHeight()
            DispatchQueue.main.async { 
                self.tableView.reloadData()
            }
        }
    }
    //Mark: --- 该APP指定常用索引 name 1 , goodsno 2, cunit 3, fqty 4, 自定义字段 5
    var dataIndexArray = [Int]()
    
    
    //Mark: --- 记录是哪个cell被改变了
    var currentModifyIndexPath:IndexPath?
    
    //Mark: --- 自定义列的数据源
    var customColDataSource = [String?]() {
        didSet {
            //属性观察者
            if let currentIndexPath = self.currentModifyIndexPath {
                let cell = tableView.cellForRow(at: currentIndexPath) as! GridTVVCCell
                cell.state = .didCharged
            }
        }
    }
    
    
    //Mark: --- cell是否展开标志数组 === 默认当然是关闭的啦
    var foldFlagArray = [Bool]()
    
    //Mark: --- 处理每个cell的详情视图的高度的数组
    var detailCellRowHeight = [CGFloat]()
    
    func initialFoldFlagArray() {
        if let dataSource = self.dataSource {
            for _ in 0..<dataSource.count {
                foldFlagArray.append(true)
            }
        }
    }
    func initialDetailCellRowHeight() {
        if let dataSource = self.dataSource {
            for i in 0..<dataSource.count {
                if let count = dataSource[i].Store_Request_list?.count {
                    detailCellRowHeight.append(CGFloat(count * 30))
                } else {
                    detailCellRowHeight.append(20)
                }
            }
        }
    }
    
    //Mark: --- 数组,存放所有的label
    var allLabelsArr = [[UILabel]]()
    
    //Mark: --- 是否添加左/右滑手势
    var isAddSwipeGesture:Bool?
    
    /* 可选UI配置项 */
    //Mark: --- headerView的高度
    var titleViewHeight:CGFloat?
    
    //Mark: --- headerView的背景色
    var titleViewBgColor:UIColor?
    
    //Mark: --- headerView的字体颜色
    var titleTextColor:UIColor?
    
    //Mark: --- rowHeight
    var rowHeight:CGFloat?
    
    //Mark: --- 设置cell的背景色
    var cellBgColor:UIColor?
    
    
    init(style: UITableViewStyle, titleArr:[String], frame:CGRect) {
        super.init(style: .plain)
        
        self.titleArr = titleArr
        self.tableView.frame = frame
        self.tableView.separatorStyle = .none
        initTitleWidthWeight()
    }
    
    func initTitleWidthWeight() {
        if titleWidthWeight.count != titleArr.count {
            titleWidthWeight.removeAll()
            for _ in 0..<titleArr.count {
                titleWidthWeight.append(1)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GridTVVCCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GridTVVCCell = GridTVVCCell.init(style: .default, reuseIdentifier: "cellID", labelCount: titleArr.count, labelWidthWeight:titleWidthWeight)
        cell.no = indexPath.row + 1
        cell.indexPath = indexPath
        cell.isAddSwipeGesture = self.isAddSwipeGesture
        cell.dataIndexArray = self.dataIndexArray
        cell.delegate  = self
        cell.rowHeight = self.rowHeight != nil ? self.rowHeight : (self.view.height - 20)/10
        if let dataSource = dataSource {
            if self.customColDataSource.count != 0 {
                cell.customColValue = self.customColDataSource[indexPath.row]
                if self.customColDataSource[indexPath.row] != nil {
                    if self.cellBgColor != nil {
                        cell.backgroundColor = cellBgColor
                    } else {
                        cell.backgroundColor = UIColor.colorFromHex(0xC8FFEA)
                    }
                }
            }
            cell.model = dataSource[indexPath.row]
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellRowheight:CGFloat = 0
        if let rowHeight = rowHeight {
            cellRowheight =  rowHeight
        } else {
            cellRowheight = (self.view.height - 20)/10
        }
        
        let isFold = foldFlagArray[indexPath.row]
        if isFold {
            return cellRowheight
        } else {
            return cellRowheight + detailCellRowHeight[indexPath.row] + 10
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let height = titleViewHeight {
            return height
        } else {
            return 20
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 20)
        let titleCounts = titleArr.count
        var maxX:CGFloat = 0
        for i in 0..<titleCounts {
            let widthWeight = CGFloat(titleWidthWeight[i]) / CGFloat(titleWidthWeight.reduce(0){
                $0 + $1
            })
            let width = view.width * widthWeight
            var height:CGFloat = 0
            if let titleViewHeight = titleViewHeight {
                height = titleViewHeight
            } else {
                height = view.height
            }
            
            let frame = CGRect(x: maxX, y: 0, width: width, height: height)
            maxX = maxX + width
            
            let btn = UIButton.init(type: .custom)
            btn.setTitle(titleArr[i], for: .normal)
            let titleTextColor = self.titleTextColor == nil ? UIColor.white : self.titleTextColor!
            btn.setTitleColor(titleTextColor, for: .normal)
            btn.frame = frame
            btn.tag = i
            btn.addTarget(self, action: #selector(titleBtnClickAction(sender:)), for: .touchUpInside)
            btn.titleLabel?.font = font(15)
            btn.titleLabel?.textAlignment = .center
            view.addSubview(btn)
        }
        
        let bgColor = self.titleViewBgColor == nil ? UIColor.colorFromHex(0x5DECB8) : UIColor.gray
        view.backgroundColor = bgColor
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.gridTableView(tableView, didSelectRowAt: indexPath)
        }
    }
    
    //Mark: --- 设置代理进行回调
    func titleBtnClickAction(sender:UIButton) {
        print("Click标题:\(titleArr[sender.tag])")
    }
    
    
    var delegate:GridTVVCDelegate?
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let delegate = self.delegate {
            delegate.gridTableViewDidScroll(scrollView)
        }
    }

}

extension GridTVVC:GridTVVCCellDelegate {
    
    func gridTVVCCellDidClick(btn: UIButton, btnType: GridTVVCCellBtnType, cellIndexPath: IndexPath?) {
        if let delegate = self.delegate {
            delegate.gridTVVCCellDidClick(btn: btn, btnType: btnType, cellIndexPath: cellIndexPath)
        }
    }
    
    func gridTVVCCellDidSwipe(gesture: UISwipeGestureRecognizer, topView: UIView, botView: UIView, isSwipeLeft: Bool?, state: GridTVVCCellState?) {
        
        if let oldCell = currentSwipeCell {
            let newCell = gesture.view as! GridTVVCCell
            if newCell.indexPath != oldCell.indexPath {
                UIView.animate(withDuration: 0.5, animations: {
                    oldCell.topView.transform = CGAffineTransform(translationX: 0, y: 0)
                    oldCell.botView.alpha = 0
                })
            }
        }
        currentSwipeCell = gesture.view as? GridTVVCCell
        
        var tX:CGFloat = -200
        var isAlpha:CGFloat = 0
        if let cellState = state {
            switch cellState {
            case .didCharged:
                tX = -200
                isAlpha = 1
            default:
                tX = -100
                isAlpha = 0
            }
        }
        
        if let isSwiper = isSwipeLeft {
            switch isSwiper {
            case true:
                botView.subviews.first?.alpha = isAlpha
                UIView.animate(withDuration: 0.5, animations: { 
                    topView.transform = CGAffineTransform(translationX: tX, y: 0)
                    botView.alpha = 1
                })
            case false:
                UIView.animate(withDuration: 0.5, animations: {
                    topView.transform = CGAffineTransform(translationX: 0, y: 0)
                    botView.alpha = 0
                })
            }
        }
    }
}





