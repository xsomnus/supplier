//
//  DisCmtOwnBidDetailVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Moya

let disCmtGridVCHeight:CGFloat =  kScreenH - kStatusBarH - kNavigationBarH

class DisCmtOwnBidDetailVC: BaseVC {
    
    let provider = MoyaProvider<ApiManager>()
    
    //Mark: --- 数据源:RepGoodsModels
    var dataSource = [RepGoodsModel]()
    
    //Mark: --- 单号
    var cSheetNo:String?
    
    //Mark: --- 自定义列的数据源
    var customColDataSource = [String?]()
    
    var bidGoodsModelFromDBArr:[BidGoodsInfoModel]?
    
    lazy var childGridTVVC:GridTVVC = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: WID * 20, height: kScreenH - 50)
        let vc = GridTVVC.init(style: .grouped, titleArr: ["序号", "名称", "编码", "单位", "合计", "竞价单价"], frame:rect)
        vc.titleWidthWeight = [1, 2, 2, 1, 2, 2]
        vc.dataIndexArray = [0, 1, 2, 3, 4, 5]
        vc.delegate = self
        vc.cellBgColor = UIColor.white
        return vc
        }()
    
    lazy var toBidBtn:UIButton = {[weak self] in
        let btn = UIButton.init(type: .custom)
        btn.setTitle("提交竞价单", for: .normal)
        btn.layer.backgroundColor = UIColor.colorFromHex(0x1ECF8C).cgColor
        btn.addTarget(self, action: #selector(commitMyBidOrderAction), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showNavBackBtn()
        self.navigationItem.title = "未提交生鲜补货单"
        requestDataFromDB()
    }
    
    //Mark: --- 提交竞价单
    func commitMyBidOrderAction() {
        
        if let bidGoodsModelFromDBArr = bidGoodsModelFromDBArr {
            var tmpDicArr = [Dictionary<String, Any>]()
            
            for postModel in  bidGoodsModelFromDBArr {
                postModel.EndTime = NSDate.getToday()
                tmpDicArr.append(postModel.beDict())
            }
            let json = JSON.init(tmpDicArr)
            SVProgressHUD.show()
            provider.request(.URL_UploadBid(json, "000", "路发万家")) { [weak self](result) in
                switch result {
                case let .success(response):
                    let json = JSON(response.data)
                    if json["resultStatus"] == "1" {
                        SVProgressHUD.showSuccess(withStatus: "成功提交!")
                        //1. 从数据库中移除
                        SQLManager.shareSQLManager.deleteDBWith(cSheetNo: (self?.cSheetNo!)!)
                        //2. 刷新上一个页面的视图 - 
                            //--(--1)刷新
                            NotificationCenter.default.post(name: NotifyUploadBidOrder, object: nil)
                            //--(--2)从上个页面的数据源中移除
                        
                        //3. popBack
                        SVProgressHUD.dismiss(withDelay: 1, completion: {
                            self?.popBack()
                        })
                    }
                    
                case .failure(_):
                    SVProgressHUD.setMaximumDismissTimeInterval(1.0)
                    SVProgressHUD.showError(withStatus: "网络连接出现问题")
                }
            }
        }
    }
    
    func setupUI() {
        self.addChildViewController(childGridTVVC)
        self.view.addSubview(childGridTVVC.tableView)
    }

    func requestDataFromDB() {
        //self.bidGoodsModelFromDBArr = SQLManager.shareSQLManager.selectBidGoodsModel()
        if let cSheetNo = self.cSheetNo {
            self.bidGoodsModelFromDBArr = SQLManager.shareSQLManager.selectBidGoodsModelWith(cSheetNo: cSheetNo)
        
        if let bidGoodsModelFromDBArr = bidGoodsModelFromDBArr {
            for bidGoodInfoModel in bidGoodsModelFromDBArr {
                let sourceModel = RepGoodsModel.init(JSON: [:])
                sourceModel?.cGoodsName = bidGoodInfoModel.cGoodsName
                sourceModel?.cGoodsNo   = bidGoodInfoModel.cGoodsNo
                sourceModel?.cSheetno   = bidGoodInfoModel.Bidding_cSheetno
                sourceModel?.cUnit      = bidGoodInfoModel.cUnit
                sourceModel?.fQty       = bidGoodInfoModel.fQuantity
                sourceModel?.cStoreName = "Tmp"
                sourceModel?.Store_Request_list = nil
                dataSource.append(sourceModel!)
                customColDataSource.append(bidGoodInfoModel.price)
            }
            
            self.initialCustomColDataSource()
            self.childGridTVVC.dataSource = self.dataSource
            self.childGridTVVC.customColDataSource = self.customColDataSource
            self.view.addSubview(self.toBidBtn)
            self.toBidBtn.snp.makeConstraints { (make) in
                make.width.left.right.bottom.equalToSuperview()
                make.height.equalTo(50)
            }
            
        } else {
            SVProgressHUD.setMaximumDismissTimeInterval(1)
            SVProgressHUD.showError(withStatus: "数据请求出错!")
        }
        }
    }
    
    func initialCustomColDataSource() {
        for _ in 0..<dataSource.count {
            self.customColDataSource.append(nil)
        }
        self.childGridTVVC.customColDataSource = self.customColDataSource
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension DisCmtOwnBidDetailVC:GridTVVCDelegate {
    func gridTableViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func gridTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func gridTVVCCellDidClick(btn: UIButton, btnType: GridTVVCCellBtnType, cellIndexPath: IndexPath?) {
        
    }
}
