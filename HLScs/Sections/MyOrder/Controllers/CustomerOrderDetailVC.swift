//
//  CustomerOrderDetailVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/17.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import Then
import SVProgressHUD


class CustomerOrderDetailVC: BaseVC {

    let provider = MoyaProvider<ApiManager>()
    var cSheetNo:String?
    
    lazy var customerOrderTV:OrderTableView = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 150)
        let orderView = OrderTableView.init(frame: rect, titleArr: ["", "名称", "编码", "合计", "单价¥", "海报图"])
        orderView.titleWidthWeight = [3, 8, 6, 4, 8, 10]
        orderView.cellHeight = 50
        return orderView
    }()
    
    lazy var stockBtn:UIButton = {[weak self] in
        let btn = UIButton.init(type: .custom)
        btn.setTitle("备货完成/提醒司机接货", for: .normal)
        btn.layer.backgroundColor = UIColor.colorFromHex(0x1ECF8C).cgColor
        btn.addTarget(self, action: #selector(stockFinishedAction), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
        }()
    
    
    var dataSource = [OrderCellModel]()
    
    var switchContainerView:UIView?
    var switchBoxView:UIView?
    var switchBtn:UISwitch?
    var switchLabel:UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBackBtn()
        self.view.backgroundColor = UIColor.colorFromHex(0xf8f8f8)
        
        self.navigationItem.title = "客户订单详情"
        setupUI()
        
        //requestFakeData()
        requestData()
    }
    
    func setupUI() {
        
        self.view.addSubview(customerOrderTV)
        self.view.addSubview(stockBtn)
        
        self.stockBtn.snp.makeConstraints { (make) in
            make.width.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        self.switchContainerView = UIView.init().then{
            $0.backgroundColor = UIColor.colorFromHex(0xfdfdfd)
            self.view.addSubview($0)
            $0.layer.borderColor = UIColor.colorFromHex(0xcdcdcd).cgColor
            $0.layer.borderWidth = 0.5
            $0.snp.makeConstraints({ (make) in
                make.height.equalTo(100)
                make.left.equalToSuperview().offset(-1)
                make.right.equalToSuperview().offset(1)
                make.bottom.equalToSuperview().offset(-50)
            })
        }
        self.switchBoxView = UIView.init().then {
            $0.backgroundColor = UIColor.white
            self.switchContainerView?.addSubview($0)
            $0.layer.borderColor = UIColor.colorFromHex(0xcdcdcd).cgColor
            $0.layer.borderWidth = 0.5
            $0.snp.makeConstraints({ (make) in
                make.height.equalTo(50)
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(20)
            })
        }
        self.switchBtn = UISwitch.init().then {
            switchBoxView?.addSubview($0)
            $0.frame = CGRect(x: kScreenW - WID - 51, y: 9.5, width: 51, height: 31)
            $0.transform = CGAffineTransform(scaleX: 1, y: 1)
            $0.addTarget(self, action: #selector(valueDidChangeAction(sender:)), for:.valueChanged)
        }
        self.switchLabel = UILabel.init().then {
            switchBoxView?.addSubview($0)
            $0.frame = CGRect(x: WID, y: 0, width: kScreenW - 2 * WID - 40, height: 50)
            $0.font = font(18)
            $0.text = "商品未分拣"
        }
    }
    
    func valueDidChangeAction(sender:UISwitch) {
        if sender.isOn {
            self.switchLabel?.text = "商品已分拣"
        } else {
            self.switchLabel?.text = "商品未分拣"
        }
    }
    
    func stockFinishedAction() {
        SVProgressHUD.show()
        if let cSheetNo = cSheetNo {
        if let switchBtn = switchBtn {
            provider.request(.URL_Upload_Prepare_Goods(cSheetNo, switchBtn.isOn ? "1" : "0"), completion: { (result) in
                switch result {
                case let .success(response):
                    let json = JSON(response.data)
                    if json["resultStatus"] == "1"{
                        
                        //Mark: --- 发送通知告诉未备货/已备货刷新界面
                        NotificationCenter.default.post(name: NotifyStockFinished, object: nil)
                    
                        SVProgressHUD.showSuccess(withStatus: "成功提交")
                        SVProgressHUD.dismiss(withDelay: 1)
                        self.popBack()
                    }
                case let.failure(error):
                    print(error)
                    SVProgressHUD.setMaximumDismissTimeInterval(1)
                    SVProgressHUD.showSuccess(withStatus: "提交备货失败")
                }
            })
        }
        }
    }
    
    func requestData() {
        SVProgressHUD.show()
        if let cSheetNo = cSheetNo {
        provider.request(.URL_Select_Customer_OrderContent(cSheetNo)) { (result) in
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
        } else {
            SVProgressHUD.dismiss(withDelay: 1, completion: {
                SVProgressHUD.setMaximumDismissTimeInterval(1)
                SVProgressHUD.showError(withStatus: "单号获取失败")
            })
        }
    }
}
