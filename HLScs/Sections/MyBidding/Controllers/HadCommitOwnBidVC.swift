//
//  HadCommitOwnBidVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Moya


class HadCommitOwnBidVC: BaseVC {

    let provider = MoyaProvider<ApiManager>()
    
    var tbDataSource:[FlexTableModel]?
    
    func initialTBDataSource() {
        var tmpDataSource = [FlexTableModel]()
        let infos = [("未读", "hlscs_bidvc_notread"), ("已读","hlscs_bidvc_read"), ("采纳", "hlscs_bidvc_accept"), ("驳回", "hlscs_bidvc_reject"), ("终止", "hlscs_bidvc_dead")]
        for (sectionHeaderName, sectionHeadIcon) in infos {
            let model = FlexTableModel.init()
            model.sectionHeaderName = sectionHeaderName
            model.sectionHeaderIcon = sectionHeadIcon
            tmpDataSource.append(model)
        }

        self.tbDataSource = tmpDataSource
    }
    
    var dataSource:[BidOrderStateModel]? {
        didSet {
            if let dataSource = dataSource {
                for model in dataSource {
                    switch model.Bidding_State! {
                    case "0":
                        tbDataSource?[0].childItems = model.list
                    case "1":
                        tbDataSource?[1].childItems = model.list
                    case "2":
                        tbDataSource?[2].childItems = model.list
                    case "3":
                        tbDataSource?[3].childItems = model.list
                    case "4":
                        tbDataSource?[4].childItems = model.list
                    default:
                        print("\(model.Bidding_State!)")
                    }
                }
                self.hadCmtTV.reloadData()
            }
        }
    }
    
    var flagArray = [Bool]()
    
    
    lazy var hadCmtTV:UITableView = {[weak self] in
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
        initialTBDataSource()
        //初始化数据
        makeFlagData()
        self.view.addSubview(hadCmtTV)
        
        hadCmtTV.addPullRefresh { [weak self]in
            self?.requestData()
            self?.hadCmtTV.stopPullRefreshEver()
        }
        
        requestData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUploadBidOrderAction(noti:)), name: NotifyUploadBidOrder, object: nil)
    }
    
    func didUploadBidOrderAction(noti:NSNotification) {
        requestData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func requestData() {
        SVProgressHUD.show()
        if let cSupNo = userDefault.object(forKey: userDefaultUserIDKey) {
            provider.request(.URL_Select_Bidding_Order(cSupNo as! String, NSDate.getToday()!)) { (result) in
                switch result {
                case let .success(response):
                    do {
                        self.dataSource = try response.mapArray(BidOrderStateModel.self)
                        SVProgressHUD.dismiss()
                    } catch {
                        SVProgressHUD.setMaximumDismissTimeInterval(1)
                        SVProgressHUD.showError(withStatus: "网络异常中断")
                    }
                    
                case .failure(_):
                    SVProgressHUD.setMaximumDismissTimeInterval(1)
                    SVProgressHUD.showError(withStatus: "网络连接出现问题")
                }
            }
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func makeFlagData() {
        flagArray.removeAll()
        for _ in 0...(tbDataSource?.count)! - 1 {
            flagArray.append(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension HadCommitOwnBidVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tbDataSource!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flagArray[section] {
            let model:FlexTableModel = tbDataSource![section]
            if let childItems = model.childItems {
                return childItems.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cellid")
        let model:FlexTableModel = tbDataSource![indexPath.section]
        if let childBranchs = model.childItems {
            let childBranchs =  childBranchs as! [BidOrderStateBranchModel]
            cell?.textLabel?.text = childBranchs[indexPath.row].Bidding_cSheetno
        }
        cell?.textLabel?.font = font(15)
        cell?.textLabel?.textColor = UIColor.init(gray: 98)
        
        let iconString = "hlscs_child_branch"
        cell?.imageView?.image = UIImage.init(named: iconString)
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tbDataSource?[section].sectionHeaderName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = HomeVCTVHeaderView()
        
        let model:FlexTableModel = tbDataSource![section]
        let message = (model.sectionHeaderName!, model.sectionHeaderIcon!)
        headerView.message = message
        headerView.headerID = section + 5000
        headerView.isFold = flagArray[section]
        
        headerView.tapClick = {(index:Int, isFold:Bool) in
            let ratio = index - 5000
            self.flagArray[ratio] = isFold
            self.hadCmtTV.reloadSections(IndexSet.init(integer: ratio), with: UITableViewRowAnimation.automatic)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = HadCmtBidDetailVC()
        let model:FlexTableModel = tbDataSource![indexPath.section]
        if let childBranchs = model.childItems {
            let childBranchs =  childBranchs as! [BidOrderStateBranchModel]
            vc.cSheetNo = childBranchs[indexPath.row].Bidding_cSheetno
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  section == tbDataSource!.count - 1 ? 0.5 : 10
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
