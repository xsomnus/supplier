//
//  OrderTableCell.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/17.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then

class OrderTableCell: UITableViewCell {
    
    var labelCount:Int = 0
    var labelWidthWeight = [Int]()
    var rowHeight:CGFloat?
    var indexPath:IndexPath?
    
    var detailBotViewRowCount:Int? {
        get {
            return orderCellModel?.StoreList?.count
        }
    }
    
    let topView = UIView.init()
    let detailBotView = UIView.init()
    var labelArr = [UILabel]()
    var imageBtn:UIButton?
    var orderSubViews = [UIView]()
    
    //Mark: --- 管理各个分店的标签数组, 分为分店名称/分店所要的重量
    var branchStoreNameLabelArr = [UILabel]()
    var branchStoreFQtyLabelArr = [UILabel]()
    
    
    
    var orderCellModel:OrderCellModel? {
        didSet {
            initLabelWidthWeight()
            setupDetailLabels()
            configureData()
        }
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, labelCount:Int,labelWidthWeight:[Int]) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.labelCount          = labelCount
        self.labelWidthWeight    = labelWidthWeight
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
    
    func initLabelWidthWeight() {
        if labelWidthWeight.count != labelCount {
            labelWidthWeight.removeAll()
            for _ in 0..<labelCount {
                self.labelWidthWeight.append(1)
            }
        }
    }

    func configureData() {
        if let model = orderCellModel {
            let infoArr = ["\(indexPath!.row + 1)", model.cGoodsName, model.cGoodsNo, model.fQuantity,"\(model.price!)/\(model.cUnit!)"]
            for i in 0..<labelCount-1 {
                labelArr[i].text = infoArr[i]
            }
            imageBtn?.setImage(UIImage.init(named: model.Image_Path!), for: .normal)
            
            //Mark: --- 各个分店信息数据加载
            if let branchStoreModels = model.StoreList {
                for i in 0..<branchStoreModels.count {
                    branchStoreNameLabelArr[i].text = branchStoreModels[i].cStoreName
                    branchStoreFQtyLabelArr[i].text = branchStoreModels[i].fQuantity
                }
            }
        }
    }
    
    func setupUI() {
        self.contentView.addSubview(topView)
        self.contentView.addSubview(detailBotView)
        detailBotView.backgroundColor = UIColor.colorFromHex(0xfafafa)
        //创建labels + imageView
        labelArr.removeAll()
        for i in 0..<labelCount {
            if i == labelCount - 1 {
                self.imageBtn = UIButton.init(type: .custom)
                self.imageBtn?.imageView?.contentMode = .scaleAspectFit 
                orderSubViews.append(imageBtn!)
                topView.addSubview(imageBtn!)
            } else {
                let label = UILabel.init()
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 15)
                labelArr.append(label)
                topView.addSubview(label)
                orderSubViews.append(label)
            }
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
    
    
    override func layoutSubviews() {
        if let rowHeight = rowHeight {
            
            topView.frame = CGRect(x: 0, y: 0, width: self.width, height: rowHeight)
            detailBotView.frame = CGRect(x: 0, y: rowHeight, width: self.width, height: self.height - rowHeight)
            
            // topView --- orderSubViews
            var maxX:CGFloat = 0
            for i in 0..<labelCount{
                let widthWeight = CGFloat(labelWidthWeight[i]) / CGFloat(labelWidthWeight.reduce(0){
                    $0 + $1
                })
                let width = self.contentView.width * widthWeight
                let frame = CGRect(x: maxX, y: 0, width: width, height:rowHeight)
                maxX = maxX + width
                orderSubViews[i].frame = frame
            }
            
            // detailBotView -- labels
            if let detailBotViewRowCount = self.detailBotViewRowCount {
                let detailLabelWidth:CGFloat = 80
                for i in 0..<detailBotViewRowCount {
                    branchStoreNameLabelArr[i].frame = CGRect(x: (self.width - 2 * detailLabelWidth)/2, y: CGFloat(i)*30 + 5, width: detailLabelWidth, height: 30)
                    branchStoreFQtyLabelArr[i].frame = CGRect(x: (self.width - 2 * detailLabelWidth)/2 + detailLabelWidth, y: CGFloat(i)*30 + 5, width: detailLabelWidth, height: 30)
                }
            }
            
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}








