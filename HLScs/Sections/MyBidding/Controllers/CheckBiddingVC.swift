//
//  CheckBiddingVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/11.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//


import UIKit
import Moya
import Then
import SVProgressHUD

class CheckBiddingVC: BaseVC {
    
    let provider = MoyaProvider<ApiManager>()
    
    var startDate:String?
    
    var homeDataSource: [HomeVCModel] {
        get {
            var dataSource:[HomeVCModel] = []
            HomeVCModel(sectionHeaderName: "路发万家", sectionHeaderIcon: "hlscs_store_icon", childItems: ["补货单汇总"]).append(arr: &dataSource)
            
            return dataSource
        }
    }
    var flagArray = [Bool]()
    
    //日期控件视图
    lazy var datePickerBtn:DatePickerBtn = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: 50)
        let dateView = DatePickerBtn.init(frame: rect)
        dateView.setBtnTitle(startDate: NSDate.getPreviousDay()!, endDate: NSDate.getToday()!)
        dateView.delegate = self
        return dateView
        }()
    
    
    lazy var homeTV:UITableView = {[weak self] in
        let rect = CGRect(x: 0, y: 50, width: kScreenW, height: kScreenH - kStatusBarH - kNavigationBarH - 50)
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
        self.navigationItem.title = "查看补货单"
        
        //初始化数据
        makeFlagData()
        
        showNavBackBtn()
        self.view.addSubview(homeTV)
        self.view.addSubview(datePickerBtn)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func makeFlagData() {
        flagArray.removeAll()
        for index in 0...homeDataSource.count - 1 {
            if index == 0 || index == 1 {
                flagArray.append(true)
            } else {
                flagArray.append(false)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}


extension CheckBiddingVC:UITableViewDelegate, UITableViewDataSource {
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
        let repOrderDetailVC = RepOrderDetailVC()
        if let startDate = startDate {
            repOrderDetailVC.startDate = startDate
        } else {
            startDate    = NSDate.getToday()
        }
        self.navigationController?.pushViewController(repOrderDetailVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  section == homeDataSource.count - 1 ? 0.5 : 10
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

extension CheckBiddingVC:DatePickerBtnDelegate {
    func datePickerBtnDidCommit(startDate: String, endDate: String) {
        self.startDate = startDate
    }
}




