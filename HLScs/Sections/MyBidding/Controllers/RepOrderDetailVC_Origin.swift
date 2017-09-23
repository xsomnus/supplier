//
//  RepOrderDetailVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/11.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import Then

let infoHeaderHeight:CGFloat = 50
let gridVCHeight:CGFloat =  kScreenH - kStatusBarH - kNavigationBarH - infoHeaderHeight - 60

class RepOrderDetailVC: BaseVC {
    
    let provider = MoyaProvider<ApiManager>()
    var dataSource:String?
    
   
    
    lazy var childGridTVVC:GridTVVC = {[weak self] in
        let rect = CGRect(x: 0, y: 50, width: WID * 15, height: gridVCHeight + kStatusBarH + kNavigationBarH)
        let vc = GridTVVC.init(style: .grouped, titleArr: ["序号", "名称", "编码", "单位", "合计"], frame:rect)
        vc.titleWidthWeight = [1, 2, 2, 1, 1]
        return vc
    }()
    lazy var childGridTVAsideView:GridTVAsideView = {[weak self] in
        let rect = CGRect(x: WID*15, y: 50, width: WID * 5, height: gridVCHeight)
        let gridTVAsideView = GridTVAsideView.init(frame: rect, titleArr: ["福星店","岗厦店","福田店", "罗湖店"])
        return gridTVAsideView
    }()
    
    lazy var pageBtnView:PageBtnView = {[weak self] in
        
        let rect = CGRect(x: 0, y: gridVCHeight + infoHeaderHeight + 10 , width: kScreenW, height: 30)
        print(rect)
        let pageBtnView = PageBtnView.init(frame: rect, pageCount: 10)
        pageBtnView.delegate = self
        return pageBtnView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "生鲜补货单"
        self.navigationItem.leftBarButtonItem = setBackBarButtonItem()
        self.addChildViewController(childGridTVVC)
        
        self.view.addSubview(childGridTVVC.view)
        self.view.addSubview(childGridTVAsideView)
        self.view.addSubview(pageBtnView)
        
        requestData()
    }

    func requestData() {
        provider.request(.URL_RepOrderDetail("1117", "2017-3-23")) { (result) in
            switch result {
            case let .success(response):
                let statusCode = response.statusCode
                let data = response.data
                let json = JSON(data)
                print("\(statusCode)----\(json)")
            case let .failure(error):
                print(error)
            }

        }
    }
    
    // MARK: - 返回按钮
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
    
}

//Mark: --- 点击页面按钮之后返回页面索引, 进行数据请求, 以及刷新数据
extension RepOrderDetailVC:PageBtnViewDelegate {
    func pageBtnViewDidSelect(index: Int) {
        print("Select:\(index)")
    }
}
