//
//  HomeVC.swift
//  HLScs
//
//  Created by @xwy_brh on 29/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import Moya
import Then
import SVProgressHUD

class HomeVC: BaseVC {
    
    let provider = MoyaProvider<ApiManager>()
    var homeDataSource: [HomeVCModel] {
        get {
            var dataSource:[HomeVCModel] = []
            HomeVCModel(sectionHeaderName: "我竞价", sectionHeaderIcon: "hlscs_offer_icon", childItems: ["查看补货单", "我的竞价单"]).append(arr: &dataSource)
            HomeVCModel(sectionHeaderName: "查订单", sectionHeaderIcon: "hlscs_check_orders_icon", childItems: ["客户订单"]).append(arr: &dataSource)
            HomeVCModel(sectionHeaderName: "谁接货", sectionHeaderIcon: "hlscs_receive_icon", childItems: ["待发货", "物流验货单(已发货)"]).append(arr: &dataSource)
            HomeVCModel(sectionHeaderName: "我查查", sectionHeaderIcon: "hlscs_lookup_icon", childItems: ["已完成订单", "退货单", "库存查询", "销售查询", "往来账", "竞品分析"]).append(arr: &dataSource)
            HomeVCModel(sectionHeaderName: "新品申请", sectionHeaderIcon: "hlscs_newgoods_icon", childItems: ["新品推荐申请单", "查看已提交新品推荐"]).append(arr: &dataSource)
            return dataSource
        }
    }
    var flagArray = [Bool]()
    
    
    
    lazy var homeTV:UITableView = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kStatusBarH - kNavigationBarH)
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
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "首页"
        
        //初始化数据
        makeFlagData()
        
        //Mark: -- 隐藏左边返回按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: UIView.init())
        
        self.view.addSubview(homeTV)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Mark: -- 禁用pop手势
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func makeFlagData() {
        flagArray.removeAll()
        for _ in 0...homeDataSource.count - 1 {
            flagArray.append(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}


extension HomeVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flagArray[section] {
            return (homeDataSource[section].childItems?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cellid")
        let model:HomeVCModel = homeDataSource[indexPath.section]
        
        cell?.textLabel?.text = model.childItems?[indexPath.row]
        cell?.textLabel?.font = font(15)
        cell?.textLabel?.textColor = UIColor.init(gray: 98)
        
        let iconString = "hlscs_child_branch"
        cell?.imageView?.image = UIImage.init(named: iconString)
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return homeDataSource[section].sectionHeaderName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = HomeVCTVHeaderView()
        
        let model:HomeVCModel = homeDataSource[section]
        let message = (model.sectionHeaderName!, model.sectionHeaderIcon!)
        headerView.message = message
        headerView.headerID = section + 5000
        headerView.isFold = flagArray[section]
        
        headerView.tapClick = {(index:Int, isFold:Bool) in
                let ratio = index - 5000
                self.flagArray[ratio] = isFold
                self.homeTV.reloadSections(IndexSet.init(integer: ratio), with: UITableViewRowAnimation.automatic)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Mark: --- 我竞价
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let checkBidVC = CheckBiddingVC()
                self.navigationController?.pushViewController(checkBidVC, animated: true)
            case 1:
                let myownBidVC = MyOwnBidVC()
                self.navigationController?.pushViewController(myownBidVC, animated: true)
            default:
                showNotOpenInfo()
            }
        }
        //Mark: --- 查订单
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let customerOrderVC = CustomerOrderVC()
                self.navigationController?.pushViewController(customerOrderVC, animated: true)
            default:
                showNotOpenInfo()
            }
        }
        //Mark: --- 谁接货
        else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                let notDeliveryOrderVC = NotDeliveryOrderVC()
                self.navigationController?.pushViewController(notDeliveryOrderVC, animated: true)
            case 1:
                let didDeliveryOrderVC = DidDeliveryOrderVC()
                self.navigationController?.pushViewController(didDeliveryOrderVC, animated: true)
            default:
                showNotOpenInfo()
            }
        }
        //Mark: --- 新品申请
        else if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                let newGoodsVC = NewGoodsRequestVC1()
                self.navigationController?.pushViewController(newGoodsVC, animated: true)
            case 1:
                let checkNewGoodsVC = CheckNewGoodsRequestVC()
                self.navigationController?.pushViewController(checkNewGoodsVC, animated: true)
            default:
                showNotOpenInfo()
            }
        }
        //Mark: --- 未开发功能提醒
        else {
            showNotOpenInfo()
        }
    }
    
    func showNotOpenInfo() {
        SVProgressHUD.showInfo(withStatus: "此功能暂未开放, 敬请期待!")
        SVProgressHUD.dismiss(withDelay: 1.2)
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  section == homeDataSource.count - 1 ? 0.5 : 20
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






