//
//  CheckMyOrderVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/17.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Moya
import Then
import SVProgressHUD
import SwiftyJSON

class NotReadyCustomerOrderVC: BaseVC {

    var dataSource:[CheckCustomerOrderModel]? {
        didSet {
            //Mark: --- 数据模型转换
            if let dataSource = dataSource {
                tbDataSource.removeAll()
                for model in dataSource {
                    let tbModel = FlexTableModel()
                    tbModel.sectionHeaderIcon = "hlscs_store_icon"
                    tbModel.sectionHeaderName = model.cStoreName
                    tbModel.childItems = model.list
                    tbDataSource.append(tbModel)
                }
                //初始化数据
                makeFlagData()
                self.checkCustomerOrderTV.reloadData()
            }
        }
    }
    
    var tbDataSource = [FlexTableModel]()
    let provider = MoyaProvider<ApiManager>()
    
    var flagArray = [Bool]()
    
    
    lazy var checkCustomerOrderTV:UITableView = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kStatusBarH - kNavigationBarH - 50 - 50)
        let tableView = UITableView.init(frame: rect, style: .grouped)
        tableView.separatorStyle = .none
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cellid")
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
        }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(checkCustomerOrderTV)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stockFinishedAction(noti:)), name: NotifyStockFinished, object: nil)
        self.checkCustomerOrderTV.addPullRefresh { [weak self] in
            self?.requestData()
            self?.checkCustomerOrderTV.stopPullRefreshEver()
        }
        
        requestData()
    }
    
    func stockFinishedAction(noti:Notification) {
        requestData()
    }
    
    func makeFlagData() {
        flagArray.removeAll()
        if tbDataSource.count == 0 {
            return
        }
        for _ in 0..<tbDataSource.count {
            flagArray.append(true)
        }
    }
    
    func requestData() {
        dataSource?.removeAll()
        SVProgressHUD.show()
        
        if let cSupNo = userDefault.object(forKey: userDefaultUserIDKey) {
            provider.request(.URL_Select_Customer_Order(cSupNo as! String, NSDate.getToday()!)) { (result) in
                switch result {
                case let .success(response):
                    do {
                        self.dataSource = try response.mapArray(CheckCustomerOrderModel.self)
                        SVProgressHUD.dismiss()
                    } catch {
                    SVProgressHUD.dismiss()
                    }
                
                case .failure(_):
                    SVProgressHUD.dismiss()
                }
            }
        } else {
            SVProgressHUD.showError(withStatus: "供应商信息丢失!")
            SVProgressHUD.dismiss(withDelay: 1)
        }
    }
}

extension NotReadyCustomerOrderVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tbDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flagArray.count == 0 {
            return 0
        } else {
            if flagArray[section] {
                return (tbDataSource[section].childItems?.count)!
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cellid")
        let model:FlexTableModel = tbDataSource[indexPath.section]
        
        if let childItems = model.childItems {
            let childItems = childItems as! [CheckCustomerListBranchModel]
            cell?.textLabel?.text = childItems[indexPath.row].Head_affirm_cSheetno
        }
        
        cell?.textLabel?.font = font(15)
        cell?.textLabel?.textColor = UIColor.init(gray: 98)
        
        let iconString = "hlscs_child_branch"
        cell?.imageView?.image = UIImage.init(named: iconString)
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tbDataSource.count == 0 {
            return nil
        } else {
           return tbDataSource[section].sectionHeaderName
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = HomeVCTVHeaderView()
        
        let model:FlexTableModel = tbDataSource[section]
        let message = (model.sectionHeaderName!, model.sectionHeaderIcon!)
        headerView.message = message
        headerView.headerID = section + 5000
        
        if flagArray.count != 0 {
            headerView.isFold = flagArray[section]
        }
        
        headerView.tapClick = {(index:Int, isFold:Bool) in
            let ratio = index - 5000
            self.flagArray[ratio] = isFold
            self.checkCustomerOrderTV.reloadSections(IndexSet.init(integer: ratio), with: UITableViewRowAnimation.automatic)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //mark跳转到订单页面
        let VC = CustomerOrderDetailVC()
        
        let model:FlexTableModel = tbDataSource[indexPath.section]
        
        if let childItems = model.childItems {
            let childItems = childItems as! [CheckCustomerListBranchModel]
            VC.cSheetNo = childItems[indexPath.row].Head_affirm_cSheetno
        }
        
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  section == tbDataSource.count - 1 ? 0.5 : 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init()
        
        _ = UIView().then {
            $0.backgroundColor = UIColor.colorFromHex(0xD3D3D3)
            footerView.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.height.equalTo(0.5)
                make.width.top.left.equalToSuperview()
            })
        }
        _ = UIView().then {
            $0.backgroundColor = UIColor.colorFromHex(0xD3D3D3)
            footerView.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.height.equalTo(0.5)
                make.width.bottom.left.equalToSuperview()
            })
        }
        
        footerView.backgroundColor = UIColor.colorFromHex(0xFBFBFB)
        
        return  footerView
    }
    
}







