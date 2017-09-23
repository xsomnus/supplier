//
//  HadCmtBidDetailVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/19.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import Then
import SVProgressHUD

class HadCmtBidDetailVC: BaseVC {

    
    let provider = MoyaProvider<ApiManager>()
    var cSheetNo:String?
    
    lazy var customerOrderTV:OrderTableView = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 150)
        let orderView = OrderTableView.init(frame: rect, titleArr: ["", "名称", "编码", "合计", "单价¥", "海报图"])
        orderView.titleWidthWeight = [1, 6, 6, 6, 8, 10]
        orderView.cellHeight = 50
        return orderView
        }()
    
    lazy var stockBtn:UIButton = {[weak self] in
        let btn = UIButton.init(type: .custom)
        btn.setTitle("提醒商家", for: .normal)
        btn.layer.backgroundColor = UIColor.colorFromHex(0x1ECF8C).cgColor
        btn.addTarget(self, action: #selector(stockFinishedAction), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
        }()
    
    
    var dataSource = [OrderCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBackBtn()
        self.navigationItem.title = "竞价单详情"
        self.view.addSubview(customerOrderTV)
        self.view.addSubview(stockBtn)
        requestData()
        
    }

    func stockFinishedAction(){
        
    }
    
    func requestData() {
        if let cSheetNo = self.cSheetNo {
            provider.request(.URL_Select_Bidding_OrderContent(cSheetNo)) { (result) in
                switch result {
                case let .success(response):
                    do {
                        self.dataSource = try response.mapArray(OrderCellModel.self)
                        SVProgressHUD.dismiss(completion: {
                            self.customerOrderTV.dataSource = self.dataSource
                        })
                    } catch {
                        print(error)
                    }
                case let .failure(error):
                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                        SVProgressHUD.setMaximumDismissTimeInterval(1)
                        SVProgressHUD.showError(withStatus: error.failureReason ?? "网络连接出现问题")
                    })
                }
            }
        
        }
    
    }

}
