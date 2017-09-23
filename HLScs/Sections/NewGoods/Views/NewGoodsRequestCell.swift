//
//  NewGoodsRequestCell.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then

class NewGoodsRequestCell: UITableViewCell {

    var titleText:String? {
        didSet {
            self.contentView.addSubview(inputTextField)
        }
    }
    
    lazy var inputTextField:UITextField = {[weak self] in
        let textfield = UITextField.init()
       
        textfield.leftViewMode = .always
        let asideBtn = TitleLeftBtn.init(type: .custom)
        asideBtn.setTitle(self?.titleText, for: .normal)
        asideBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        asideBtn.setTitleColor(UIColor.colorFromHex(0x030303), for: .normal)
        textfield.leftView = asideBtn
        
        
        textfield.placeholder = "请输入\((self?.titleText)!)"
        textfield.textColor = UIColor.init(gray: 232)
        textfield.clearButtonMode = UITextFieldViewMode.always
        textfield.font = UIFont.systemFont(ofSize: 15)
        
        return textfield
        }()
    var sepView = UIView.init()
    
    init(frame:CGRect) {
        super.init(style: .default, reuseIdentifier: "dotdotdot")
        self.frame = frame
        
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(sepView)
        sepView.backgroundColor = UIColor.colorFromHex(0xf2f2f2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        inputTextField.frame = self.bounds
        inputTextField.leftView?.frame = CGRect(x: 0, y: 0, width: kScreenW/4, height: (self.height))
        sepView.frame = CGRect(x: WID, y: self.height - 0.5, width: self.width - WID, height: 0.5)
    }
    
}

