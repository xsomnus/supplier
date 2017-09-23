//
//  ApiManager.swift
//  HLScs
//
//  Created by @xwy_brh on 29/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON


enum ApiManager:TargetType {
    case URL_Login(String, String)      //登录
    case URL_Offter     //我竞价
    case URL_RepOrderDetail(String, String) //查看补货单
    case URL_Sorted     //我分拣
    case URL_CA         //往来账
    case URL_Delivery   //谁接货
    case URL_LookUp     //我查查
    case URL_NewGoods   //新品申请
    case URL_UploadBid(JSON, String, String)  //提交竞价单
    case URL_Select_Bidding_Order(String, String) //查询已提交的竞价单
    case URL_Select_Bidding_OrderContent(String) //竞价单详情
    case URL_Upload_New_Products(JSON) //新品申请提交
    case URL_Select_New_Products(String) //新品推荐查看
    case URL_Select_Customer_Order(String, String) //查看我的订单的汇总信息
    case URL_Select_Customer_OrderContent(String)  //查看订单详情链接
    case URL_Select_driver_the_adress(String)      //查看司机信息
    case URL_Select_driver_the_position(String)    //查看司机位置信息
    case URL_Upload_Prepare_Goods(String, String)  //客户订单处理, 提交分拣信息
    case URL_Select_Prepare_cSheetNo(String, String) //已备货信息接口
    case URL_Select_Prepare_Goods(String, String)
    case URL_Select_Unshipped_cSheetno(String, String)  //待发货二级界面接口
    case URL_Select_Yi_shipped_cSheetno(String, String) //已发货接口
    
}

//let defaultURL = "http://192.168.15.53:1237"
let defaultURL = "http://www.jclingshou.com:50174"
//let defaultURL = "http://222.73.129.25:39389"
extension ApiManager {
    
    var baseURL: URL {
        return URL.init(string: defaultURL)!
        //return URL.init(string: "http://zhaoqiuyang.xicp.net:26338")!
        //return URL.init(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .URL_Login:
            return "/YingYunTong/Supplier_Login"
        case .URL_RepOrderDetail:
            return "/YingYunTong/Select_Head_RequestOrder"
        case .URL_UploadBid:
            return "/YingYunTong/Upload_Bidding"
        case .URL_Select_Bidding_Order:
            return "/YingYunTong/Select_Bidding_Order"
        case .URL_Upload_New_Products:
            return "/YingYunTong/Upload_New_Products"
        case .URL_Select_New_Products:
            return "/YingYunTong/Select_New_Products"
        case .URL_Select_Customer_Order:
            return "/YingYunTong/Select_Customer_Order"
        case .URL_Select_Customer_OrderContent:
            return "/YingYunTong/Select_Customer_OrderContent"
        case .URL_Select_driver_the_adress:
            return "/YingYunTong/Select_driver_the_adress"
        case .URL_Select_driver_the_position:
            return "/YingYunTong/Select_driver_the_adress"
        case .URL_Upload_Prepare_Goods:
            return "/YingYunTong/Upload_Prepare_Goods"
        case .URL_Select_Bidding_OrderContent:
            return "/YingYunTong/Select_Bidding_OrderContent"
        case .URL_Select_Prepare_Goods:
            return "/YingYunTong/Select_Prepare_Goods"
        case .URL_Select_Prepare_cSheetNo:
            return "/YingYunTong/Select_Prepare_cSheetNo"
        case .URL_Select_Unshipped_cSheetno:
            return "/YingYunTong/Select_Unshipped_cSheetno"
        case .URL_Select_Yi_shipped_cSheetno:
            return "/YingYunTong/Select_Yi_shipped_cSheetno"
        default:
            return "defaultURL"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .URL_RepOrderDetail:
            return .get
        case .URL_Select_driver_the_adress:
            return .post
        case .URL_Select_driver_the_position:
            return .get
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .URL_Login(let name, let pwd):
            var params:[String: Any] = [:]
            params["cSupNo"] = name
            params["cSupPassword"] = pwd
            return params
            
        case .URL_RepOrderDetail(let supUserNo, let dDate):
            var params:[String: Any] = [:]
            params["cSupNo"] = supUserNo
            params["dDate"] = dDate
            return params
            
        case .URL_UploadBid(let json, let Head_cStoreNo, let Head_cStoreName):
            var params:[String: Any] = [:]
            params["data"] = json
            params["Head_cStoreNo"] = Head_cStoreNo
            params["Head_cStoreName"] = Head_cStoreName
            return params
            
        case .URL_Select_Bidding_Order(let cSupNo, let dDate):
            var params:[String: Any] = [:]
            params["cSupNo"] = cSupNo
            params["dDate"] = dDate
            return params
            
        case .URL_Upload_New_Products(let json):
            var params:[String:Any] = [:]
            params["data"] = json
            return params
    
        case .URL_Select_New_Products(let cSupNo):
            var params:[String: Any] = [:]
            params["cSupNo"] = cSupNo
            return params
        case .URL_Select_Customer_Order(let cSupNo, let dDate):
            var params:[String : Any] = [:]
            params["cSupNo"] = cSupNo
            params["dDate"] = dDate
            return params
        case .URL_Select_Customer_OrderContent(let cSheetNo):
            var params:[String: Any] = [:]
            params["cSheetNo"] = cSheetNo
            return params
        case .URL_Select_driver_the_adress(let cSheetNo):
            var params:[String: Any] = [:]
            params["cSheetNo"] = cSheetNo
            return params
        case .URL_Select_driver_the_position(let cSheetNo):
            var params:[String: Any] = [:]
            params["cSheetNo"] = cSheetNo
            return params
        case .URL_Upload_Prepare_Goods(let cSheetNo, let iSsort):
            var params:[String: Any] = [:]
            params["cSheetNo"] = cSheetNo
            params["iSsort"]   = iSsort
            return params
        case .URL_Select_Bidding_OrderContent(let cSheetNo):
            var params:[String: Any] = [:]
            params["cSheetNo"] = cSheetNo
            return params
        case .URL_Select_Prepare_Goods(let cSupNo, let dDate):
            var params:[String: Any] = [:]
            params["cSupNo"] = cSupNo
            params["dDate"]  = dDate
            return params
        case .URL_Select_Prepare_cSheetNo(let cSupNo, let dDate):
            var params:[String: Any] = [:]
            params["cSupNo"] = cSupNo
            params["dDate"]  = dDate
            return params
        case .URL_Select_Unshipped_cSheetno(let cSupNo, let dDate):
            var params:[String: Any] = [:]
            params["cSupNo"] = cSupNo
            params["dDate"]  = dDate
            return params
        case .URL_Select_Yi_shipped_cSheetno(let cSupNo, let dDate):
            var params:[String: Any] = [:]
            params["cSupNo"] = cSupNo
            params["dDate"]  = dDate
            return params
        default:
            return nil
        }
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

    var task: Task {
        return .request
    }
    
    var validate: Bool {
        return false
    }
    /*
    var multipartBody: [Moya.MultipartFormData]? {
        switch self {
        case .URL_Upload_New_Products(let _):
            return [json]
        default:
            return nil
        }
    }
     */
}





