//
//  TestMapVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/18.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Moya
import SVProgressHUD
import SwiftyJSON

let logisticTVTotalHeight:CGFloat = (kScreenH - kNavigationBarH - kStatusBarH - 40)

enum LogisticState{
    /*
     订单状态
     0 -- 未备货
     1 -- 已备货
     2 -- 司机接单
     3 -- 已收货/验货
     4 -- 送达总部
     */
    case notAccept  // 司机未接单
    case accept     // 司机已接单
    case arrive     // 司机已送达
    case confirm    // 总部确认收货
}

class LogisticDetailVC: BaseVC {
    
    let provider = MoyaProvider<ApiManager>()
    let cellHeightWeight = [3, 4, 8, 2, 3]
    
    //Mark: --- 订单对应的物流状态值
    var logisticState:LogisticState?
    
    var cSheetNo:String?          //订单单号
    /*
     订单状态
     0 -- 未备货
     1 -- 已备货
     2 -- 司机接单
     3 -- 已收货/验货
     4 -- 送达总部
     */
    var Head_affirm_State:String?
    var rowCount:Int {
        get {
            drawLineFromTop(rowCount: 5)
            return 5
        }
    }
    
    var timer:Timer?
    var bdMapView:BMKMapView?
    var bmkMapAna:BMKAnnotation?
    var driverModel:DeliveryDriverModel? {
        didSet {
            guard let driverModel = driverModel else {
                return
            }
            let lat:Double = (driverModel.latitude! as NSString).doubleValue
            let lon:Double = (driverModel.longitude! as NSString).doubleValue
            driverPosition = CLLocationCoordinate2D.init(latitude: lat, longitude: lon)
            self.logisticTV.reloadData()
            
            //初始化定时器
            initTimer()
        }
    }
    var _bmkCell:DeliveryDetailBMKCell?
    
    func initTimer(){
        guard logisticState == LogisticState.accept else {
            return
        }
        timer = Timer(timeInterval: 1, target: self, selector: #selector(requestDriverPosition), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        timer?.fire()

    }
    //Mark: --- 请求司机位置信息
    func  requestDriverPosition() {
        provider.request(.URL_Select_driver_the_position(self.cSheetNo!)) { (result) in
            switch result {
            case let .success(response):
                _ = JSON(response.data)
                do {
                    let driverModel:DeliveryDriverModel = try response.mapArray(DeliveryDriverModel.self).first!
                    self.driverPosition = driverModel.position!
                    
                    /*
                    DispatchQueue.main.async(execute: {
                        self.logisticTV.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .automatic)
                    })
                     */
                } catch {
                    if (self.timer?.isValid)! {
                        self.timer?.invalidate()
                    }
                }
            case let .failure(error):
                print(error)
                if (self.timer?.isValid)! {
                    self.timer?.invalidate()
                }
            }
        }
        
    }
    
    deinit {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    //Mark: --- 每次设置值得时候,可以发送通知, 让cell发生变化;第一次的时候, 可以init一个值
    var driverPosition:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 30.15667, longitude: 114.31667) {
        didSet {
            let cell = self.logisticTV.cellForRow(at: IndexPath.init(row: 2, section: 0))
            if cell != nil {
                let bmkCell = cell as! DeliveryDetailBMKCell
                bmkCell.driverPosition = driverPosition
            }
        }
    }
    
    lazy var logisticTV:UITableView = {[weak self] in
        let rect = CGRect(x: WID*3, y: 20, width: kScreenW - 4*WID, height: kScreenH - kNavigationBarH - kStatusBarH - 20)
        let tableview = UITableView.init(frame: rect, style: .plain)
    
        tableview.register(DeliveryDetailCell.self, forCellReuseIdentifier: "DeliveryDetailCellID")
        tableview.dataSource = self
        tableview.delegate   = self
        tableview.separatorStyle = .none
        tableview.bounces = false
        return tableview
        }()
    
    func initLogisticState() {
        guard let Head_affirm_State = Head_affirm_State else {
            return
        }
        let state = (Head_affirm_State as NSString).integerValue
        switch state {
        case 0,1:
            logisticState = LogisticState.notAccept
        case 2:
            logisticState = LogisticState.accept
        case 3:
            logisticState = LogisticState.arrive
        default:
            logisticState = LogisticState.confirm
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBackBtn()
        self.navigationItem.title = "物流详情"
        initLogisticState()
        configureLogisticTV()
        requestData()
    
        //Mark: --- 画线
        //drawLineFromMid()
        //Mark: --- 配置左边的单号二维码按钮
        configureQRCode()
       
    }
    
    func configureQRCode() {
     
        let barcodeBtn = UIButton.init(type: .custom)
        barcodeBtn.setImage(UIImage(named: "hlscs_barcode"), for: .normal)
        barcodeBtn.sizeToFit()
        barcodeBtn.frame.size = CGSize(width: 30, height: 30)
        barcodeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        barcodeBtn.addTarget(self, action: #selector(showQRCodeAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: barcodeBtn)
        
    }
    
    func showQRCodeAction() {
        if let cSheetNo = cSheetNo {
            let VC = QRCodeVC()
            VC.cSheetNo = cSheetNo
            self.navigationController?.pushViewController(VC, animated: true)
        } else {
            SVProgressHUD.showError(withStatus: "单号出现异常, 请重新再试")
        }
    }
    
    var startYArr:[CGFloat]? {
        get {
            let cellHeightArr = cellHeightWeight.map {
                (logisticTVTotalHeight * (CGFloat($0)/CGFloat(cellHeightWeight.reduce(0){$0 + $1})))/2
            }
            var dealtYArr = [CGFloat]()
            for i in 0..<cellHeightArr.count-1 {
                dealtYArr.append(cellHeightArr[i] + cellHeightArr[i+1])
            }
            var startY = 20 + cellHeightArr[0]
            var startYArr = [startY]
            _ = dealtYArr.map { (y) -> CGFloat in
                startY = y + startY
                startYArr.append(startY)
                return startY
            }
            return startYArr
        }
    }
    
    var startYArrTop:[CGFloat]? {
        get {
            let cellHeightArr = cellHeightWeight.map {
                logisticTVTotalHeight * (CGFloat($0)/CGFloat(cellHeightWeight.reduce(0){$0 + $1}))
            }
            var startY:CGFloat = 20 + cellHeightArr[0]*0.67*0.5
            var startTopYArr = [startY]
            _ = cellHeightArr.map({ (topY) -> CGFloat in
                startY = topY + startY
                startTopYArr.append(startY)
                return startY
            })
            startTopYArr.removeLast()
            return startTopYArr
        }
    }
    
    func drawLineFromTop(rowCount:Int) {
        let shapeLayer = CAShapeLayer.init()
        let linePath   = UIBezierPath.init()
        let startAngle: CGFloat = CGFloat(Double.pi / 2 + Double.pi)
        let endAngle: CGFloat = CGFloat(Double.pi / 2 + Double.pi + 3*Double.pi)
        let radius:CGFloat = 8
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = Double(rowCount) * 0.6
        
        if let startYArr = startYArrTop {
            let startPoint = CGPoint(x: WID * 1.5, y:startYArr[0] - radius)
            linePath.move(to: startPoint)
            for (i, y) in startYArr.enumerated() {
                
                
                let point = CGPoint(x: WID * 1.5, y: y)
                linePath.addArc(withCenter: point, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                if i < startYArr.count - 1 {
                    linePath.addLine(to: CGPoint(x: WID * 1.5, y: startYArr[i+1] - radius))
                }
                
                if i >= rowCount - 1 {
                    break
                }
            }
        }
        
        shapeLayer.path = linePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.colorFromHex(0xF3D546).cgColor
        shapeLayer.add(animation, forKey: nil)
        self.view.layer.addSublayer(shapeLayer)
    }
    
    func drawLineFromMid() {
        let shapeLayer = CAShapeLayer.init()
        let linePath   = UIBezierPath.init()
        let startAngle: CGFloat = CGFloat(Double.pi / 2 + Double.pi)
        let endAngle: CGFloat = CGFloat(Double.pi / 2 + Double.pi + 3*Double.pi)
        let radius:CGFloat = 8
      
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = Double(rowCount) * 0.6
        
        if let startYArr = startYArr {
            let startPoint = CGPoint(x: WID * 1.5, y:startYArr[0] - radius)
            linePath.move(to: startPoint)
            for (i, y) in startYArr.enumerated() {
                let point = CGPoint(x: WID * 1.5, y: y)
                linePath.addArc(withCenter: point, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                if i < startYArr.count - 1 {
                    linePath.addLine(to: CGPoint(x: WID * 1.5, y: startYArr[i+1] - radius))
                }
            }
        }
        
        shapeLayer.path = linePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.colorFromHex(0xF3D546).cgColor
        shapeLayer.add(animation, forKey: nil)
        self.view.layer.addSublayer(shapeLayer)
    }
    
    func requestData() {
        SVProgressHUD.show()
        provider.request(.URL_Select_driver_the_adress(self.cSheetNo!)) { (result) in
            switch result {
            case let .success(response):
                do {
                    
                    self.driverModel = try response.mapArray(DeliveryDriverModel.self).first
                    SVProgressHUD.dismiss()
                } catch {
                   
                    SVProgressHUD.dismiss()
                }
            case .failure(_):
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func configureLogisticTV() {
        self.view.addSubview(logisticTV)
    }
    
}

extension LogisticDetailVC:UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let widthWeight = CGFloat(cellHeightWeight[indexPath.row]) / CGFloat(cellHeightWeight.reduce(0){
            $0 + $1
        })
        return logisticTVTotalHeight*widthWeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 2 {
            let cell = DeliveryDetailBMKCell.init(style: .default, reuseIdentifier: "BMKMapCellID")
            cell.dataArr = ["司机正在赶来", NSDate.getToday()]
            cell.driverPosition = driverPosition
            cell.selectionStyle = .none
            self._bmkCell = cell
            return cell
        } else if indexPath.row == 0 {
            let cell = DDThirdCell.init(style: .default, reuseIdentifier: "DDThirdCellID")
            cell.dataArr = ["竞价单已提交", NSDate.getToday(), "总部已采纳确认"]
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            let cell = DeliveryDetailCell.init(style: .default, reuseIdentifier: "DeliveryDetailCellID")
            if let driverModel = self.driverModel {
                if let truckLicenseTag = driverModel.TruckLicenseTag,
                    let driveName = driverModel.Driver {
                cell.dataArr = ["司机已接单", NSDate.getToday(), driverModel.tel, "师傅姓名:\t\(driveName)", "车牌号:\t\(truckLicenseTag)"]
                }
            } else {
                cell.dataArr = ["司机已接单", NSDate.getToday(), " ","师傅姓名:\t","车牌号:\t"]
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 3 {
            let cell = DDFourthCell.init(style: .default, reuseIdentifier: "DefaultCELLID")
            cell.dataArr = ["司机已确认收货", NSDate.getToday()]
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = DDSecondCell.init(style: .default, reuseIdentifier: "DDSecondCellID")
            cell.dataArr = ["商家确认收货", NSDate.getToday(), "020-7777777"]
            cell.selectionStyle = .none
            return cell
        }
    
    }
}


extension LogisticDetailVC:BMKMapViewDelegate {
    
}













