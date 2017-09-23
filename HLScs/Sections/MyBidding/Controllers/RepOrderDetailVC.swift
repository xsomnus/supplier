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
import SVProgressHUD

let infoHeaderHeight:CGFloat = 50
let gridVCHeight:CGFloat =  kScreenH - kStatusBarH - kNavigationBarH - infoHeaderHeight - 50

class RepOrderDetailVC: BaseVC {
    
    let provider = MoyaProvider<ApiManager>()
    
    //Mark: --- 开始时间 / 用于请求数据, 从上个页面传递过来的
    var startDate:String?
    
    //Mark: --- 数据源:RepGoodsModels
    var dataSource = [RepGoodsModel]()
    
    //Mark: --- 记录是哪个cell被改变了
    var currentModifyIndexPath:IndexPath?
    
    //Mark: --- 自定义列的数据源
    var customColDataSource = [String?]() {
        didSet {
            self.childGridTVVC.currentModifyIndexPath = self.currentModifyIndexPath
            self.childGridTVVC.customColDataSource = self.customColDataSource
        }
    }
    
    //Mark: --- 已经报价的数据源
    var hadBidGoodsModel = [SingleGoosBidResultModel]()
    
    //Mark: --- 要存放到数据中的数据源对象
    var hadBidGoodsModelForDB = [BidGoodsInfoModel]()

    
    lazy var childGridTVVC:GridTVVC = {[weak self] in
        let rect = CGRect(x: 0, y: 50, width: WID * 20, height: gridVCHeight + kStatusBarH + kNavigationBarH)
        let vc = GridTVVC.init(style: .grouped, titleArr: ["序号", "名称", "编码", "单位", "合计", "竞价单价"], frame:rect)
        vc.titleWidthWeight = [1, 2, 2, 1, 2, 2]
        vc.dataIndexArray   = [0, 1, 2, 3, 4, 5]
        vc.delegate = self
        vc.isAddSwipeGesture = true
        return vc
    }()
    
    
    
    /*
    lazy var pageBtnView:PageBtnView = {[weak self] in
        
        let rect = CGRect(x: 0, y: gridVCHeight + infoHeaderHeight + 10 , width: kScreenW, height: 30)
        print(rect)
        let pageBtnView = PageBtnView.init(frame: rect, pageCount: 10)
        pageBtnView.delegate = self
        return pageBtnView
    }()
    */
    
    lazy var toBidBtn:UIButton = {[weak self] in
        let btn = UIButton.init(type: .custom)
        btn.setTitle("保存竞价单", for: .normal)
        btn.layer.backgroundColor = UIColor.colorFromHex(0x1ECF8C).cgColor
        btn.addTarget(self, action: #selector(saveMyBidOrderAction), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }()
    
    func getHadBidGoodsCount() -> Int {
        return self.customColDataSource.filter {
            $0 != nil
        }.count
    }
    
    func saveMyBidOrderAction() {
        if getHadBidGoodsCount() == 0 {
            SVProgressHUD.showInfo(withStatus: "您还没有进行任何商品的竞价")
            SVProgressHUD.dismiss(withDelay: 1)
            return
        }
        
        var totalPrice:Float = 0
        for model in self.hadBidGoodsModelForDB {
            if let price = model.price,
                let fqty = model.fQuantity {
                let price = (price as NSString).floatValue
                let fqty  = (fqty as NSString).floatValue
                totalPrice = totalPrice + price*fqty
                
            }
        }
        
        let totalPriceString = String(format: "%.2f", totalPrice)
        let message:String = "竞价信息汇总\n\n您竞价商品种类合计:\t\(self.hadBidGoodsModelForDB.count)\n补货单商品种类合计:\t\(self.dataSource.count)\n您竞价商品金额合计:\t¥\(totalPriceString)\n\n是否确定保存此次竞价?"
        
        
        let alertVC = UIAlertController.init(title: message, message: "提醒\n(1)竞价单保存后无法对此补货单的其他的商品进行竞价\n(2)竞价单可于[首页]->[我竞价]->[我的竞价单]查看", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        let confirmAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
            for model in self.hadBidGoodsModelForDB {
                _ =  SQLManager.shareSQLManager.insertModel(model: model)
            }
            self.popBack()
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    func toBidBtnAction(){
        let vc = BiddingVC()
        vc.dataSource = self.dataSource
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "生鲜补货单"
        self.navigationItem.leftBarButtonItem = setBackBarButtonItem()
        self.addChildViewController(childGridTVVC)
        self.view.addSubview(childGridTVVC.view)
        //self.view.addSubview(pageBtnView)
        
        self.view.addSubview(self.toBidBtn)
        self.toBidBtn.snp.makeConstraints { (make) in
            make.width.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        self.toBidBtn.alpha = 0
        childGridTVVC.view.alpha = 0
        showNavBackBtn()
        requestData()
        //requestFakeData()
    }

    func initialCustomColDataSource() {
        for _ in 0..<dataSource.count {
            self.customColDataSource.append(nil)
        }
        self.childGridTVVC.customColDataSource = self.customColDataSource
    }
    
    func requestFakeData() {
         for _ in 0..<100 {
         let model:RepGoodsModel = RepGoodsModel.init(JSON: [:])!
         model.cGoodsName = "香蕉"
         model.cGoodsNo = "1222"
         model.fQty = "12.22"
         model.cSheetno = "1222222222"
         model.cUnit = "kg"
         var branchModelArr = [BranchStoreRepModel]()
         for _ in 0..<arc4random() % 4 {
         let branchModel = BranchStoreRepModel.init(JSON: [:])!
         branchModel.fQty = "2"
         branchModel.cStoreName = "华夏学院"
         branchModel.cGoodsNo = "12222"
         branchModelArr.append(branchModel)
         }
         model.Store_Request_list = branchModelArr
        self.dataSource.append(model)
         }
         
         self.initialCustomColDataSource()
         self.childGridTVVC.dataSource = self.dataSource
         
        self.toBidBtn.alpha = 1
        self.childGridTVVC.view.alpha = 1
    }
    
    
    func requestData() {
        SVProgressHUD.show()
        
        let startDate = self.startDate != nil ? self.startDate : NSDate.getToday()!
        if let cSupNo = userDefault.object(forKey: userDefaultUserIDKey) {
            provider.request(.URL_RepOrderDetail(cSupNo as! String, startDate!)) { (result) in
            switch result {
            case let .success(response):
                
                //let statusCode = response.statusCode
                do {
                    self.dataSource = try response.mapArray(RepGoodsModel.self)
                    self.initialCustomColDataSource()
                    self.childGridTVVC.dataSource = self.dataSource
                    
                    SVProgressHUD.dismiss(completion: { 
                        self.toBidBtn.alpha = 1
                        self.childGridTVVC.view.alpha = 1
                    })
                   
                } catch {
                    //let error = MoyaError.jsonMapping(response)
                    SVProgressHUD.setMaximumDismissTimeInterval(1)
                    SVProgressHUD.showError(withStatus: "数据请求出错,错误类型\(response.statusCode)")
                    
                }
                
            case .failure(_):
                SVProgressHUD.setMaximumDismissTimeInterval(1)
                SVProgressHUD.showError(withStatus: "网络连接出现问题")
            }

        }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.dismiss()
    }

    func toSingleGoodsBidVC(indexPath:IndexPath) {
        let vc = SingleGoodsBidVC()
        
        let goodsModel = self.dataSource[indexPath.row]
        vc.goodsModel = goodsModel
        vc.indexNo = indexPath.row
        vc.indexPath = indexPath
        
        for model in self.hadBidGoodsModel {
            if model.indexPath == indexPath {
                vc.state = .modify
                vc.modifyModel = model
            }
        }
        
        //Mark: --- 闭包回调方法
        vc.saveClick  = { model in
            // 1. 修改竞价单价的值
            self.currentModifyIndexPath = indexPath
            self.customColDataSource[model.indexNo!] = model.price

            self.hadBidGoodsModel.append(model)
            
            // 2. 保存数据模型到数据库中
            
            //Mark: --- 由于后台没有返回cSheetNo, 所以需要自己手动设置, 对于每一次提交都生成一个单号
            let sheetNoArr = SQLManager.shareSQLManager.selectCSheetNoTypeCounts()
            var nextNo:Int = 0
            if let sheetNoArr = sheetNoArr {
                for value in sheetNoArr {
                    if nextNo < value {
                        nextNo = value
                    }
                }
                nextNo = nextNo + 1
            } else {
                nextNo = 0
            }
            
            
                //2.1 将数据转换成数据库模型 -- BidGoodsInfoModel
            let bidGoodInfoModel = BidGoodsInfoModel.init()
            
                bidGoodInfoModel.Bidding_cSheetno = "\(nextNo)"
                bidGoodInfoModel.price = model.price
                bidGoodInfoModel.Image_Path = model.imagePathArr?.first
                bidGoodInfoModel.cUnit = goodsModel.cUnit
                bidGoodInfoModel.cSpuer = userDefault.object(forKey: userDefaultUserIDKey) as? String
                bidGoodInfoModel.cGoodsName = goodsModel.cGoodsName
                bidGoodInfoModel.cSpuer_No = userDefault.object(forKey: userDefaultUserIDKey) as? String
                bidGoodInfoModel.cGoodsNo_State = "1"
                bidGoodInfoModel.fQuantity = goodsModel.fQty
                bidGoodInfoModel.cGoodsNo = model.cGoodsNo
                bidGoodInfoModel.StartTime = NSDate.getToday()
                bidGoodInfoModel.EndTime = nil
                bidGoodInfoModel.indexPath = model.indexPath
                //Mark: --- 设置分拣信息数据信息保存
            var tempDicArr = [[String:Any]]()
            if let Store_Request_list = goodsModel.Store_Request_list {
                for branchModel in Store_Request_list {
                    let branchModelDic = branchModel.beDict()
                    tempDicArr.append(branchModelDic)
                }
            }
            if let branchStr = JSON.init(rawValue: tempDicArr) {
                bidGoodInfoModel.branchStoreList = "\(branchStr)"
            }
                //2.2 将数据库模型保存在数组中
            self.hadBidGoodsModelForDB.append(bidGoodInfoModel)
            // 3. 刷新视图
            self.childGridTVVC.tableView.reloadData()
            
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Mark: --- 取消报价
    func cancelGoodsBidding(indexPath:IndexPath) {
        let alertVC = UIAlertController.init(title: "是否确定取消该商品的竞价", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        let confirmAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
            self.currentModifyIndexPath = indexPath
            self.customColDataSource[indexPath.row] = nil
            //从数据库模型数组中移除, 从已添加模型的数组中移除
            for model in self.hadBidGoodsModel {
                if model.indexPath == indexPath {
                    if let i = self.hadBidGoodsModel.index(where: { (model) -> Bool in
                        return true
                    }) {
                        self.hadBidGoodsModel.remove(at: i)
                    }
                }
            }
            for model in self.hadBidGoodsModelForDB {
                if model.indexPath == indexPath {
                    if let i = self.hadBidGoodsModelForDB.index(where: { (model) -> Bool in
                        return true
                    }) {
                        self.hadBidGoodsModelForDB.remove(at: i)
                    }
                }
            }
            
            self.childGridTVVC.tableView.reloadData()
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(confirmAction)
        
        self.present(alertVC, animated: true) { 
            
        }
        
    }
}

extension RepOrderDetailVC:GridTVVCDelegate {
    
    
    func gridTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
         //控制cell的折叠
         self.childGridTVVC.foldFlagArray[indexPath.row] = !self.childGridTVVC.foldFlagArray[indexPath.row]
         tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func gridTableViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func gridTVVCCellDidClick(btn: UIButton, btnType: GridTVVCCellBtnType, cellIndexPath: IndexPath?) {
        if let indexPath = cellIndexPath {
            switch btnType {
            case .bidOrModify:
                toSingleGoodsBidVC(indexPath: indexPath)
            case .cancelBid:
                cancelGoodsBidding(indexPath: indexPath)
            }
        }
    }
    
}

//Mark: --- 点击页面按钮之后返回页面索引, 进行数据请求, 以及刷新数据
/*
extension RepOrderDetailVC:PageBtnViewDelegate {
    func pageBtnViewDidSelect(index: Int) {
        print("Select:\(index)")
    }
}
*/











