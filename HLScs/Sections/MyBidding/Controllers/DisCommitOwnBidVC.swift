//
//  DisCommitOwnBidVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then

class DisCommitOwnBidVC: BaseVC {
    

    var flagArray = [Bool]()
    
    var cSheetNoArr:[Int]? {
        didSet {
            dataSource.removeAll()
            let flexTableModel = FlexTableModel()
            flexTableModel.sectionHeaderName = "路发万家"
            flexTableModel.sectionHeaderIcon = "hlscs_store_icon"
            if let cSheetNoArr = cSheetNoArr {
                flexTableModel.childItems = cSheetNoArr
            }
            dataSource.append(flexTableModel)
            makeFlagData()
            self.discmtTV.reloadData()
        }
    }

    var dataSource  = [FlexTableModel]()
    
    lazy var discmtTV:UITableView = {[weak self] in
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
        //初始化数据
        makeFlagData()
        self.view.addSubview(discmtTV)
        
        self.discmtTV.addPullRefresh { [weak self] in
            self?.requestDataFromDB()
            self?.discmtTV.stopPullRefreshEver()
        }
        
        requestDataFromDB()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUploadBidOrderAction(noti:)), name: NotifyUploadBidOrder, object: nil)
    }
    
    func didUploadBidOrderAction(noti:NSNotification) {
        requestDataFromDB()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func requestDataFromDB() {
        self.cSheetNoArr = SQLManager.shareSQLManager.selectCSheetNoTypeCounts()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func makeFlagData() {
        flagArray.removeAll()
        if dataSource.count == 0 {
            return
        }
        for _ in 0...dataSource.count - 1 {
            flagArray.append(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension DisCommitOwnBidVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flagArray.count == 0 {
            return 0
        }
        if flagArray[section] {
            return (dataSource[section].childItems?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cellid")
        let model:FlexTableModel = dataSource[indexPath.section]
        
        if let childItems = model.childItems {
           let childItems = childItems as! [Int]
            cell?.textLabel?.text = "我的竞价单:\t\(childItems[indexPath.row])"
        }
        
        cell?.textLabel?.font = font(15)
        cell?.textLabel?.textColor = UIColor.init(gray: 98)
        
        let iconString = "hlscs_child_branch"
        cell?.imageView?.image = UIImage.init(named: iconString)
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].sectionHeaderName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = HomeVCTVHeaderView()
        
        let model:FlexTableModel = dataSource[section]
        let message = (model.sectionHeaderName!, model.sectionHeaderIcon!)
        headerView.message = message
        headerView.headerID = section + 5000
        if flagArray.count != 0 {
            headerView.isFold = flagArray[section]
        } else {
            headerView.isFold = false
        }
        headerView.tapClick = {(index:Int, isFold:Bool) in
            let ratio = index - 5000
            self.flagArray[ratio] = isFold
            self.discmtTV.reloadSections(IndexSet.init(integer: ratio), with: UITableViewRowAnimation.automatic)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DisCmtOwnBidDetailVC()
        
        let model:FlexTableModel = dataSource[indexPath.section]
        
        if let childItems = model.childItems {
            let childItems = childItems as! [Int]
            vc.cSheetNo = "\(childItems[indexPath.row])"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  section == dataSource.count - 1 ? 0.5 : 10
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

