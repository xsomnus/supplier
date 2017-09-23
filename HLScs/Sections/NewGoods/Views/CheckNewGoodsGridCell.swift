//
//  CheckNewGoodsGridCell.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class CheckNewGoodsGridCell: UICollectionViewCell {
 
    
    var goodsModel:NewGoodsRequestModel? {
        didSet {
            var valuesArr = [String?]()
            valuesArr.append(goodsModel?.cGoodsName)
            valuesArr.append(goodsModel?.cSpec)
            valuesArr.append(goodsModel?.Price)
            valuesArr.append(goodsModel?.cUnit)
            valuesArr.append(goodsModel?.cBarcode)
            valuesArr.append(goodsModel?.Applicant)
            self.bottomBoxContainerView?.valuesArr = valuesArr as? [String]
        }
    }
    
    lazy var topBoxView = UIView.init()
    
    lazy var goodsImageView = UIImageView.init()
    
    //Mark: --- 我是分割线
    lazy var bottomBoxView = UIView.init()
    var bottomBoxContainerView:LabelsView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        self.contentView.addSubview(topBoxView)
        topBoxView.addSubview(goodsImageView)
        goodsImageView.backgroundColor = UIColor.randomColor()
        self.contentView.addSubview(bottomBoxView)
        bottomBoxContainerView = LabelsView.init(frame: CGRect.zero, type:.grid)
        bottomBoxView.addSubview(bottomBoxContainerView!)
        
    }
    
    override func layoutSubviews() {
        topBoxView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(topBoxView.snp.width)
        }
        goodsImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 5, 5, 5))
        }
        
        bottomBoxView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(topBoxView.snp.bottom)
        }
        bottomBoxContainerView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 5, 5, 5))
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


