
//
//  DDFourthCell.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/18.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class DDFourthCell: UITableViewCell {

    var titleLabel:UILabel?
    var timeLabel:UILabel?
    
    var dataArr:[String?]? {
        didSet {
            if let dataArr = dataArr {
                titleLabel?.text = dataArr[0]
                timeLabel?.text = dataArr[1]
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
        self.contentView.addSubview(titleLabel!)
        self.contentView.addSubview(timeLabel!)
    }
    
    override func layoutSubviews() {
        
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
    }
    
}
