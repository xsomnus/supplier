//
//  QRCodeVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/21.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class QRCodeVC: BaseVC {
    
    var cSheetNo:String?
    var qrImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBackBtn()
        self.navigationItem.title = "司机确认验货/收货"
        self.view.backgroundColor = UIColor.appMainColor()
        configureImageView()
    }

    func configureImageView() {
        
        let qrContainerView = UIView.init()
        self.view.addSubview(qrContainerView)
        
        
        qrImageView = UIImageView.init().then {
            self.view.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
                make.width.height.equalTo(200)
            })
            if let cSheetNo = cSheetNo {
                $0.image = cSheetNo.generateQRCode()
            }
        }
        
    }
    

}
