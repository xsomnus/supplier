//
//  DeliveryDetailBMKCell.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/18.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then

class DeliveryDetailBMKCell: UITableViewCell {

    var topBoxView = UIView.init()
    var botBoxVIew = UIView.init()
    fileprivate static var count = 1
    
    var titleLabel:UILabel?
    var timeLabel:UILabel?
    var bmkMapView:BMKMapView?
    var bmkAno:BMKPointAnnotation = BMKPointAnnotation.init()
    var driverPosition:CLLocationCoordinate2D? {
        didSet {
            if let position = driverPosition {
                bmkAno.coordinate = position
                self.bmkMapView?.setCenter(position, animated: true)
            }
        }
    }
    
    var dataArr:[String?]? {
        didSet {
            titleLabel?.text = dataArr?[0]
            timeLabel?.text  = dataArr?[1]
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.masksToBounds = true
        setupUI()
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
        bmkMapView = BMKMapView.init()
        let mapStatus = BMKMapStatus.init()
        mapStatus.fLevel = 18
        bmkMapView?.setMapStatus(mapStatus)
        
        self.contentView.addSubview(topBoxView)
        self.contentView.addSubview(botBoxVIew)
        topBoxView.addSubview(titleLabel!)
        topBoxView.addSubview(timeLabel!)
        botBoxVIew.addSubview(bmkMapView!)
        bmkMapView?.addAnnotation(bmkAno)
    }
    override func layoutSubviews() {
        topBoxView.snp.makeConstraints { (make) in
            make.right.top.left.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        botBoxVIew.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBoxView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        if let titleLabel = titleLabel,
            let timeLabel = timeLabel {
            titleLabel.snp.makeConstraints({ (make) in
                make.top.bottom.left.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.5)
            })
            timeLabel.snp.makeConstraints({ (make) in
                make.top.bottom.right.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.5)
            })
        }
        if let bmkMapView = bmkMapView {
            bmkMapView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            })
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
