//
//  HomeVCTVHeaderView.swift
//  HLScs
//
//  Created by @xwy_brh on 30/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

typealias tapClickCallBack = (_ index:Int, _ isFold:Bool) -> Void


class HomeVCTVHeaderView: UIView {

    var headerID:Int? = nil
    var tapClick:tapClickCallBack?
    var message:(title:String, iconString:String)? {
        didSet {
            if let message = message {
                tapBtn.setTitle(message.title, for: .normal)
                tapBtn.setImage(UIImage.init(named: "hlscs_pull_up"), for: .normal)
                iconView.image = UIImage.init(named: message.iconString)
            }
        }
    }
    var isFold:Bool? {
        //Mark: --- 监测cell是否为折叠状态
        didSet {
            if let isFold = isFold {
                if isFold {
                    tapBtn.setImage(UIImage.init(named: "hlscs_pull_up"), for: .normal)
                } else {
                    tapBtn.setImage(UIImage.init(named: "hlscs_pull_down"), for: .normal)
                }
            }
        }
    }
    
    var leftBoxView  = UIView.init()
    var rightBoxView = UIView.init()
    
    lazy var iconView = {() -> UIImageView in
        let view = UIImageView.init()
        return view
    }()
    
    lazy var tapBtn:HomeVCHeaderBtn = {[weak self] in
        let btn = HomeVCHeaderBtn(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(tapClickAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var sepLine = UIView().then{
        $0.backgroundColor = UIColor.colorFromHex(0xD3D3D3)
    }
    
    func tapClickAction(sender:UIButton) {
        isFold = !isFold!
        if let headerID = headerID {
            if let tapClick = tapClick {
                tapClick(headerID, isFold!)
            }
        }
    }
    
    override init(frame:CGRect) {
        
        super.init(frame: frame)
        self.addSubview(leftBoxView)
        self.addSubview(rightBoxView)
        self.backgroundColor = UIColor.white    
        leftBoxView.addSubview(iconView)
        rightBoxView.addSubview(tapBtn)
        //rightBoxView.addSubview(sepLine)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        leftBoxView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(leftBoxView.snp.height)
        }
        iconView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
        
        rightBoxView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-5)
            make.left.equalTo(leftBoxView.snp.right).offset(10)
        }
        tapBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0.5, 0))
        }
        /*
        sepLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalToSuperview()
        }
         */
    }
    

}
