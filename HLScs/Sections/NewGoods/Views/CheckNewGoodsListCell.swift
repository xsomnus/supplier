//
//  CheckNewGoodsListCell.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class CheckNewGoodsListCell: UICollectionViewCell {
    //var titlesArr = ["商品名称", "商品规格", "竞价", "品种", "包装方式", "净含量"]
    var goodsModel:NewGoodsRequestModel? {
        didSet {
            var valuesArr = [String?]()
            valuesArr.append(goodsModel?.cGoodsName)
            valuesArr.append(goodsModel?.cSpec)
            valuesArr.append(goodsModel?.Price)
            valuesArr.append(goodsModel?.cUnit)
            valuesArr.append(goodsModel?.cBarcode)
            valuesArr.append(goodsModel?.Applicant)
            self.rightBoxContainerView?.valuesArr = valuesArr as? [String]
        }
    }
    
    
    
    lazy var leftBoxView = UIView.init()
    lazy var goodsImageView = UIImageView.init()
    
    lazy var rightBoxView = UIView.init()
    var rightBoxContainerView:LabelsView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        self.contentView.addSubview(leftBoxView)
        leftBoxView.addSubview(goodsImageView)
        goodsImageView.backgroundColor = UIColor.randomColor()
        
        self.contentView.addSubview(rightBoxView)
        rightBoxContainerView = LabelsView.init(frame: CGRect.zero, type:.list)
        rightBoxView.addSubview(rightBoxContainerView!)
    }

    
    override func layoutSubviews() {
        leftBoxView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(leftBoxView.snp.height)
        }
        goodsImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 5, 5, 5))
        }
        rightBoxView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(leftBoxView.snp.right)
        }
        rightBoxContainerView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 5, 5, 5))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LabelsView: UIView {
    var labelArr = [UILabel]()
    var titlesArr = ["商品名称", "商品规格", "竞价", "品种", "包装方式", "净含量"]
    var valuesArr:[String]? {
        didSet {
            if let values = valuesArr {
                for i in 0..<labelArr.count {
                    labelArr[i].text = "\(titlesArr[i]):\t\(values[i])"
                }
            }
        }
    }
    
    var type:NewGoodsShowState?
    
    init(frame: CGRect, type:NewGoodsShowState) {
        super.init(frame: frame)
        self.type = type
        setupLabels()
    }
    
    func setupLabels() {
        for title in titlesArr {
            let label = UILabel.init()
            label.text = "\(title):"
            labelArr.append(label)
            label.textColor = UIColor.init(gray: 100)
            label.font = UIFont.systemFont(ofSize: 12)
            self.addSubview(label)
        }
    }
    
    override func layoutSubviews() {
        if let type = self.type {
            switch type {
            case .list:
                let cellHeight:CGFloat = self.height/3
                let cellWidth:CGFloat  = self.width/2
                for i in 0..<titlesArr.count {
                    if i % 2 == 0 {
                        labelArr[i].frame = CGRect(x: 0, y: CGFloat(i/2) * cellHeight, width: cellWidth, height: cellHeight)
                    } else {
                        labelArr[i].frame = CGRect(x: cellWidth, y: CGFloat((i-1)/2) * cellHeight, width: cellWidth, height: cellHeight)
                    }
                }
            case .grid:
                let cellHeight:CGFloat = self.height/6
                let cellWidth:CGFloat  = self.width
                for i in 0..<titlesArr.count {
                    labelArr[i].frame = CGRect(x: 0, y: CGFloat(i) * cellHeight, width: cellWidth, height: cellHeight)
                    
                }
            }
        
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}














