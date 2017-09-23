//
//  GridTVVCCell.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/11.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then

enum GridTVVCCellState {
    case notCharged     //未报价
    case didCharged     //已报价
}

enum GridTVVCCellBtnType {
    case cancelBid
    case bidOrModify
}

protocol GridTVVCCellDelegate {
    func gridTVVCCellDidClick(btn:UIButton, btnType:GridTVVCCellBtnType, cellIndexPath:IndexPath?)
    func gridTVVCCellDidSwipe(gesture:UISwipeGestureRecognizer, topView:UIView, botView:UIView, isSwipeLeft:Bool?, state:GridTVVCCellState?)
}

class GridTVVCCell: UITableViewCell {

    var delegate:GridTVVCCellDelegate?
    
    //Mark: --- tableview传递过来的所有的数组
    var model:RepGoodsModel? {
        didSet {
            initLabelWidthWeight()
            setupDetailLabels()
            configureData()
        }
    }
    
    var detailBotViewRowCount:Int? {
        get {
            return model?.Store_Request_list?.count
        }
    }
    
    //Mark: --- 自定义列的数据源
    var customColValue:String? {
        didSet {
            if let customColValue = customColValue {
                let f = (customColValue as NSString).floatValue
                self.customColValue = String(format: "%.2f", f)
                state = .didCharged
            } else {
                state = .notCharged
            }
        }
    }
    
    
    var no:Int?
    var indexPath:IndexPath?
    var labelCounts:Int?
    var labelWidthWeight = [Int]()
    var dataIndexArray = [Int]()
    var rowHeight:CGFloat?
    
    //Mark: --- 管理标签数组
    var labelArr = [UILabel]()
    
    //Mark: --- 管理各个分店的标签数组, 分为分店名称/分店所要的重量
    var branchStoreNameLabelArr = [UILabel]()
    var branchStoreFQtyLabelArr = [UILabel]()
    
    
    //Mark: --- 是否添加左/右滑手势
    var isAddSwipeGesture:Bool? {
        didSet {
            if let isAdd = isAddSwipeGesture {
                if isAdd {
                    self.addSwipGesture()
                    //创建btns
                    setupBtns()
                }
            }
        }
    }
    var btnArr:[UIButton]?
    func setupBtns() {
        btnArr = [UIButton]()
        //1.取消报价 2.报价/修改
        for i in 0..<2 {
            let btn = UIButton.init(type: .custom)
            botView.addSubview(btn)
            switch i {
            case 0:
                btn.setTitle("取消竞价", for: .normal)
                btn.layer.backgroundColor = UIColor.colorFromHex(0xE15D18).cgColor
                btn.addTarget(self, action: #selector(cancelBidAction(sender:)), for: .touchUpInside)
            default:
                btn.setTitle("竞价", for: .normal)
                btn.layer.backgroundColor = UIColor.colorFromHex(0x5BCCA3).cgColor
                btn.addTarget(self, action: #selector(bidOrModifyAction(sender:)), for: .touchUpInside)
            }
            btn.setTitleColor(UIColor.white, for: .normal)
           btnArr?.append(btn)
        }
    }
    
    func setupDetailLabels() {
        //Mark: --- 创建详情视图
        if let detailBotViewRowCount = self.detailBotViewRowCount {
            for _ in 0..<detailBotViewRowCount {
                let branchStoreNameLabel = UILabel.init()
                branchStoreNameLabel.textAlignment = .center
                branchStoreNameLabel.font = UIFont.systemFont(ofSize: 12)
                detailBotView.addSubview(branchStoreNameLabel)
                branchStoreNameLabelArr.append(branchStoreNameLabel)
                
                let branchStoreFQtyLabel = UILabel.init()
                branchStoreFQtyLabel.textAlignment = .center
                branchStoreFQtyLabel.font = UIFont.systemFont(ofSize: 12)
                detailBotView.addSubview(branchStoreFQtyLabel)
                branchStoreFQtyLabelArr.append(branchStoreFQtyLabel)
            }
        }
    }
    
    func cancelBidAction(sender:UIButton) {
        if let delegate = self.delegate {
            delegate.gridTVVCCellDidClick(btn: sender, btnType: .cancelBid, cellIndexPath: self.indexPath)
        }
    }
    
    
    func bidOrModifyAction(sender:UIButton) {
        if let delegate = self.delegate {
            delegate.gridTVVCCellDidClick(btn: sender, btnType: .bidOrModify, cellIndexPath: self.indexPath)
        }
    }
    
    //Mark: --- 是否已经报价
    var state:GridTVVCCellState = .notCharged {
        //Mark: --- 属性观察
        didSet {
            switch state {
            case .notCharged:
                if let btnArr = btnArr {
                    btnArr[1].setTitle("竞价", for: .normal)
                }
            default:
                if let btnArr = btnArr {
                    btnArr[1].setTitle("修改竞价", for: .normal)
                }
            }
        }
    }
    
    func initLabelWidthWeight() {
        if let labelcounts = labelCounts {
            if labelWidthWeight.count != labelCounts {
                labelWidthWeight.removeAll()
                for _ in 0..<labelcounts {
                    self.labelWidthWeight.append(1)
                }
            }
        }
    }
    
    func configureData() {
        
        //Mark: --- name 1 , goodsno 2, cunit 3, fQty 4, 自定义字段 5
        
        let infoArr = ["\(no!)", model?.cGoodsName, model?.cGoodsNo, model?.cUnit, model?.fQty]
        var j = 0
        for i in dataIndexArray {
            if i == 5 {
                
                labelArr[j].font = UIFont.systemFont(ofSize: 18)
                labelArr[j].textColor = UIColor.appMainColor()
                labelArr[j].text = customColValue
                
            } else {
                labelArr[j].text = infoArr[i]
            }
            j = j + 1
        }
        
        //Mark: --- 各个分店信息数据加载
        if let branchStoreModels = self.model?.Store_Request_list {
            for i in 0..<branchStoreModels.count {
                branchStoreNameLabelArr[i].text = branchStoreModels[i].cStoreName
                branchStoreFQtyLabelArr[i].text = branchStoreModels[i].fQty
            }
        }
    }
    
    func setupUI() {
        
        self.contentView.addSubview(botView)
        self.contentView.addSubview(topView)
        self.contentView.addSubview(detailBotView)
        detailBotView.backgroundColor = UIColor.colorFromHex(0xfafafa)
        
        botView.alpha = 0
        self.contentView.bringSubview(toFront: topView)
        
        
        labelArr.removeAll()
        for _ in 0..<labelCounts! {
            let label = UILabel.init()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15)
            labelArr.append(label)
            topView.addSubview(label)
        }
        
    }
    
    override func layoutSubviews() {
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(rowHeight!)
        }
        botView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(rowHeight!)
        }
        detailBotView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(rowHeight!)
        }
        
        // --- labels
        var maxX:CGFloat = 0
        for i in 0..<labelCounts! {
            
            let widthWeight = CGFloat(labelWidthWeight[i]) / CGFloat(labelWidthWeight.reduce(0){
                $0 + $1
            })
            let width = self.contentView.width * widthWeight
            let frame = CGRect(x: maxX, y: 0, width: width, height:rowHeight!)
            maxX = maxX + width
            labelArr[i].frame = frame
        }
        
        // --- btns
        if let btnArr = self.btnArr {
            for i in 0..<btnArr.count {
                btnArr[i].frame = CGRect(x: self.width - CGFloat(2 - i) * 100, y: 0, width: 100, height: rowHeight!)
            }
        }
        
        // --- detailLabels
        if let detailBotViewRowCount = self.detailBotViewRowCount {
            let detailLabelWidth:CGFloat = 80
            for i in 0..<detailBotViewRowCount {
                branchStoreNameLabelArr[i].frame = CGRect(x: (self.width - 2 * detailLabelWidth)/2, y: CGFloat(i)*30 + 5, width: detailLabelWidth, height: 30)
                branchStoreFQtyLabelArr[i].frame = CGRect(x: (self.width - 2 * detailLabelWidth)/2 + detailLabelWidth, y: CGFloat(i)*30 + 5, width: detailLabelWidth, height: 30)
            }
        }
        
    }
    
    let topView = UIView.init()
    let botView = UIView.init()
    let detailBotView = UIView.init()
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, labelCount:Int,labelWidthWeight:[Int]) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.labelCounts = labelCount
        self.labelWidthWeight = labelWidthWeight
        self.layer.masksToBounds = true
        setupUI()
        
        _ = UIView().then {
            $0.backgroundColor = UIColor.colorFromHex(0xD3D3D3)
            self.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.height.equalTo(1)
                make.width.bottom.left.equalToSuperview()
            })
        }
        
    }
    
    //Mark: --- 给cell添加左/右滑手势
    func addSwipGesture() {
        
        //右划
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightGestureAction(gesture:)))
        
        //左划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftGestureAction(gesture:))).then {
            $0.direction = .left
        }
        
        self.addGestureRecognizer(swipeRightGesture)
        self.addGestureRecognizer(swipeLeftGesture)
    }
    
    func swipeLeftGestureAction(gesture:UISwipeGestureRecognizer) {
        
        /*
        UIView.animate(withDuration: 0.5) {
            self.topView.transform = CGAffineTransform(translationX: -200, y: 0)
            self.botView.alpha = 1
        }
         */
        if let delegate = delegate {
            delegate.gridTVVCCellDidSwipe(gesture: gesture, topView: self.topView, botView: self.botView, isSwipeLeft: true, state: self.state)
        }
    }
    
    func swipeRightGestureAction(gesture:UISwipeGestureRecognizer) {
        /*
        UIView.animate(withDuration: 0.5) {
            self.topView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.botView.alpha = 0
        }
         */
        if let delegate = delegate {
            delegate.gridTVVCCellDidSwipe(gesture: gesture, topView: self.topView, botView: self.botView, isSwipeLeft: false, state: self.state)
        }
    }
    
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
