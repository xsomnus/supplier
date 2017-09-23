//
//  OrderTableView.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/17.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then

protocol  OrderTableViewDelegate {
    
}

class OrderTableView: UIView {
    
    var titleArr:[String]?
    var titleWidthWeight = [Int]()
    var titleViewHeight:CGFloat?
    var titleTextColor:UIColor?
    var titleViewBgColor:UIColor?
    var cellHeight:CGFloat?
    
    //Mark: --- cell是否展开标志数组 === 默认当然是关闭的啦
    var foldFlagArray = [Bool]()
    
    //Mark: --- 处理每个cell的详情视图的高度的数组
    var detailCellRowHeight = [CGFloat]()
    
    
    var dataSource:[OrderCellModel]? {
        didSet {
            initialFoldFlagArray()
            initialDetailCellRowHeight()
            self.tableView.reloadData()
        }
    }
    
    var tableView:UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
    
    init(frame: CGRect, titleArr:[String]) {
        super.init(frame: frame)
        self.titleArr = titleArr
        configureTableView()
        initTitleWidthWeight()
    }
    
    func initTitleWidthWeight() {
        if titleWidthWeight.count != titleArr!.count {
            titleWidthWeight.removeAll()
            for _ in 0..<titleArr!.count {
                titleWidthWeight.append(1)
            }
        }
    }
    
    
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
                if let count = dataSource[i].StoreList?.count {
                    detailCellRowHeight.append(CGFloat(count * 30))
                } else {
                    detailCellRowHeight.append(20)
                }
            }
        }
    }
    
    
    func configureTableView() {
        self.tableView.register(OrderTableCell.self, forCellReuseIdentifier: "orderTableViewCellID")
        tableView.frame = self.bounds
        self.addSubview(tableView)
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func titleBtnClickAction(sender:UIButton) {
        
    }

}

extension OrderTableView:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrderTableCell.init(style: .default, reuseIdentifier: "orderTableViewCellID", labelCount: titleArr!.count, labelWidthWeight: self.titleWidthWeight)
        
        cell.indexPath = indexPath
        cell.rowHeight = cellHeight != nil ? cellHeight! : 44
        
        cell.orderCellModel = self.dataSource?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellRowheight:CGFloat = 0
        if let rowHeight = cellHeight {
            cellRowheight =  rowHeight
        } else {
            cellRowheight = 44
        }
        
        let isFold = foldFlagArray[indexPath.row]
        if isFold {
            return cellRowheight
        } else {
            return cellRowheight + detailCellRowHeight[indexPath.row] + 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //控制cell的折叠
        self.foldFlagArray[indexPath.row] = !self.foldFlagArray[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height:CGFloat = 0
        if let titleViewHeight = titleViewHeight {
            height = titleViewHeight
        } else {
            height = 30
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init()
        var height:CGFloat = 0
        if let titleViewHeight = titleViewHeight {
            height = titleViewHeight
        } else {
            height = 30
        }
        view.frame = CGRect(x: 0, y: 0, width: self.width, height: height)
        let titleCounts = titleArr!.count
        var maxX:CGFloat = 0
        for i in 0..<titleCounts {
            let widthWeight = CGFloat(titleWidthWeight[i]) / CGFloat(titleWidthWeight.reduce(0){
                $0 + $1
            })
            let width = view.width * widthWeight
            
            let frame = CGRect(x: maxX, y: 0, width: width, height: height)
            maxX = maxX + width
            
            let btn = UIButton.init(type: .custom)
            btn.setTitle(titleArr?[i], for: .normal)
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
}













