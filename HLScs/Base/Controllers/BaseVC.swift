//
//  BaseVC.swift
//  HLScs
//
//  Created by @xwy_brh on 29/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import SVProgressHUD


class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    func showNavBackBtn() {
        self.navigationItem.leftBarButtonItem = setBackBarButtonItem()
    }
    
    // MARK: - private method
    func setBackBarButtonItem() -> UIBarButtonItem {
        
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage(named: "hlscs_back_arrow"), for: .normal)
        backButton.sizeToFit()
        backButton.frame.size = CGSize(width: 30, height: 30)
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        backButton.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        return UIBarButtonItem.init(customView: backButton)
    }
    
    func popBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }

   
}
