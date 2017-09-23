//
//  DDSecondCell.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/18.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class DDSecondCell: UITableViewCell {

    var topBoxView = UIView.init()
    var botBoxView = UIView.init()
    
    var titleLabel:UILabel?
    var timeLabel:UILabel?
    var phoneBtn:DeliveryPhoneBtn?
    
    var dataArr:[String?]? {
        didSet {
            if let dataArr = dataArr {
                titleLabel?.text = dataArr[0]
                timeLabel?.text  = dataArr[1]
                phoneBtn?.setTitle(dataArr[2], for: .normal)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.masksToBounds = true
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        titleLabel = UILabel.init().then {
            $0.font             = UIFont.systemFont(ofSize: 16)
            $0.textAlignment    = .left
            
        }
        timeLabel  = UILabel.init().then {
            $0.font             = UIFont.systemFont(ofSize: 14)
            //$0.textColor        = UIColor.colorFromHex(0x999999)
            $0.textAlignment    = .right
            
        }
        
        phoneBtn   = DeliveryPhoneBtn.init(type: .custom).then {
            $0.setImage(UIImage.init(named: "hlscs_logistics_phone"), for: .normal)
            $0.setTitle("132-5350-3652", for: .normal)
            $0.setTitleColor(UIColor.colorFromHex(0x666666), for: .normal)
        }
        self.contentView.addSubview(topBoxView)
        self.contentView.addSubview(botBoxView)
        
        topBoxView.addSubview(titleLabel!)
        topBoxView.addSubview(timeLabel!)
        botBoxView.addSubview(phoneBtn!)
    }

    override func layoutSubviews() {
        topBoxView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.67)
        }
        botBoxView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        if let titleLabel = titleLabel,
            let timeLabel = timeLabel{
            titleLabel.snp.makeConstraints({ (make) in
                make.top.bottom.left.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.5)
            })
            timeLabel.snp.makeConstraints({ (make) in
                make.top.bottom.right.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.5)
            })
        }
        
        if let phoneBtn = phoneBtn {
            phoneBtn.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            })
        }
    }

    
}


class DeliveryPhoneBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var titleRect = titleLabel?.frame
        var imageViewRect = imageView?.frame
        imageViewRect?.origin.x = 0
        imageViewRect?.size.width = (imageViewRect?.size.height)!
        imageView?.frame = imageViewRect!
        titleRect?.origin.x = (imageViewRect?.size.width)! + 10
        titleLabel?.frame = titleRect!
    }
    
}
