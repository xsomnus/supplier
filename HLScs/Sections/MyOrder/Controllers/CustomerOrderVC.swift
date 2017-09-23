//
//  CustomerOrderVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/17.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class CustomerOrderVC: BaseVC {

    //日期控件视图
    lazy var datePickerBtn:DatePickerBtn = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: 50)
        let dateView = DatePickerBtn.init(frame: rect)
        dateView.setBtnTitle(startDate: NSDate.getPreviousDay()!, endDate: NSDate.getToday()!)
        return dateView
        }()
    
    //分页导航pageTitleView
    lazy var customerOrderPageTitleView:PageTitleView = {[weak self] in
        let rect = CGRect(x: 0, y: 50, width: kScreenW, height: 50)
        let pagetitleView = PageTitleView.init(frame: rect, titles: ["未备货", "已备货"])
        pagetitleView.delegate = self
        return pagetitleView
        }()
    
    //Mark: --- 分页导航内容控制器视图
    lazy var customerOrderPageContentView:PageContentView = {[weak self] in
        let contentFrame = CGRect(x: 0, y:  100 + 0.5, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 100)
        var childVcs = [UIViewController]()
        childVcs.append(NotReadyCustomerOrderVC())
        childVcs.append(ReadyCustomerOrderVC())
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
        //MARK:- 控制器作为PageContentViewDelegate代理
        contentView.delegate = self
        return contentView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBackBtn()
        self.navigationItem.title = "客户订单"
        setupUI()
    }
    
    func setupUI(){
        self.view.addSubview(datePickerBtn)
        self.view.addSubview(customerOrderPageTitleView)
        self.view.addSubview(customerOrderPageContentView)
    }
}


extension CustomerOrderVC:PageTitleViewDelegate {
    
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        customerOrderPageContentView.setCurrentIndex(currentIndex: index)
    }
}

extension CustomerOrderVC:PageContentViewDelegate {
    
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        customerOrderPageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func pageContentView(index: Int, vc: UIViewController) -> UITableView? {
        switch index {
        case 0:
            let vc1 = vc as! NotReadyCustomerOrderVC
            return vc1.checkCustomerOrderTV
        case 1:
            let vc1 = vc as! ReadyCustomerOrderVC
            return vc1.checkCustomerOrderTV
        default:
            return nil
        }
    }
}

