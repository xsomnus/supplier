//
//  NavigationVC.swift
//  HLScs
//
//  Created by @xwy_brh on 29/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UIColor.appMainColor()
        // 设置naviBar背景图片
        UINavigationBar.appearance().setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        // 设置title的字体及颜色
        let textAttr =  [NSFontAttributeName: UIFont.systemFont(ofSize: 20.0), NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = textAttr
        self.interactivePopGestureRecognizer?.delegate = nil
        
        self.navigationBar.isTranslucent = false
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
