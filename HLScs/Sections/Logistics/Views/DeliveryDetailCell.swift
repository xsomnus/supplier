//
//  DeliveryDetailCell.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/18.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then
import SVProgressHUD

class DeliveryDetailCell: UITableViewCell {

    var topBoxView = UIView.init()
    var botBoxView = UIView.init()
    
    var titleLabel:UILabel?
    var timeLabel:UILabel?
    var phoneBtn:DeliveryPhoneBtn?
    var asideLabel:UILabel?
    var driveNameLabel:UILabel?
    
    
    var dataArr:[String?]? {
        didSet {
            if let dataArr = dataArr {
                
                if  let titleLabel = titleLabel,
                    let timeLabel = timeLabel {
                    titleLabel.text = dataArr[0]
                    timeLabel.text  = dataArr[1]
                }
                
                phoneBtn?.setTitle(dataArr[2], for: .normal)
                if let driverString = dataArr[3] {
                    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: driverString)
                    attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14),range: NSMakeRange(0,5))
                    attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18),range: NSMakeRange(5,driverString.characters.count-5))
                    attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0.9194, green: 0.4728, blue: 0.1742, alpha: 1),range: NSMakeRange(5, driverString.characters.count-5))
                    driveNameLabel?.attributedText = attributeString
                }
                if let truckLicenseTag = dataArr[4] {
                    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: truckLicenseTag)
                    attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14),range: NSMakeRange(0,4))
                    attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18),range: NSMakeRange(4,truckLicenseTag.characters.count-4))
                    attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0.9194, green: 0.4728, blue: 0.1742, alpha: 1),range: NSMakeRange(4, truckLicenseTag.characters.count-4))
                    asideLabel?.attributedText = attributeString
                }
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
            $0.addTarget(self, action: #selector(phoneCallAction(sender:)), for: .touchUpInside)
            
        }
        
        driveNameLabel = UILabel.init().then {
            $0.font             = UIFont.systemFont(ofSize: 14)
            $0.textColor        = UIColor.colorFromHex(0x999999)
            $0.textAlignment    = .left
        }
        
        asideLabel = UILabel.init().then {
            $0.font             = UIFont.systemFont(ofSize: 14)
            $0.textColor        = UIColor.colorFromHex(0x999999)
            $0.textAlignment    = .left
           
        }
 
        self.contentView.addSubview(topBoxView)
        self.contentView.addSubview(botBoxView)
        
        topBoxView.addSubview(titleLabel!)
        topBoxView.addSubview(timeLabel!)
        
        botBoxView.addSubview(phoneBtn!)
        botBoxView.addSubview(asideLabel!)
        botBoxView.addSubview(driveNameLabel!)
    }
    
    func phoneCallAction(sender:UIButton) {
        if let phoneNumber = sender.titleLabel?.text  {
            if phoneNumber == " " {
                SVProgressHUD.showInfo(withStatus: "电话不能为空!");
                return
            }
            UIApplication.shared.open(URL.init(string: "telprompt://\(phoneNumber)")!, options: [:], completionHandler: nil)
        }
    }
    
    override func layoutSubviews() {
        topBoxView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        botBoxView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
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
        
        if let phoneBtn = phoneBtn,
            let asideLabel = asideLabel,
            let driveNameLabel = driveNameLabel{
            phoneBtn.snp.makeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.5)
            })
            driveNameLabel.snp.makeConstraints({ (make) in
                make.bottom.left.equalToSuperview()
                make.right.equalTo(asideLabel.snp.left)
                make.width.equalTo(asideLabel.snp.width)
                make.height.equalToSuperview().multipliedBy(0.5)
            })
            asideLabel.snp.makeConstraints({ (make) in
                make.bottom.right.equalToSuperview()
                make.width.equalTo(driveNameLabel.snp.width)
                make.left.equalTo(driveNameLabel.snp.right)
                make.height.equalToSuperview().multipliedBy(0.5)
            })
        }
        
        
    }

}




