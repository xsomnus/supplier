//
//  BidGoodsInfoModel.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/13.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

class BidGoodsInfoModel: NSObject {

    /*
     "EndTime": "2017-04-13",
     "Image_Path": "/storage/sdcard0/HuanHuan/IMG_20170413_114101.png",
     "StartTime": "2017-04-13",
     "cGoodsName": "平菇",
     "cGoodsNo": "10019",
     "cGoodsNo_State": "1",
     "cSpec": "kg",
     "cSpuer": "1117",
     "cSpuer_No": "1117",
     "cUnit": "斤",
     "fQuantity": "128.0000",
     "price": "8"
    */
    
    var cGoodsNo:String?
    var cGoodsName:String?
	var fQuantity:String?
    var cUnit:String?
    var cSpec:String?
    var Bidding_cSheetno:String?
    var cGoodsNo_State:String?
    var price:String?
    var Image_Path:String?
    
    var cSpuer_No:String?
    var cSpuer:String?
    
    var StartTime:String?
    var EndTime:String?
    var indexPath:IndexPath?
    //Mark: --- 各个分店需要的重量数据 -- JSON字符串
    var branchStoreList:String?
    var branchStoreListJSON:JSON?
    
    func beDict() -> Dictionary<String, Any> {
        var dic = [String:Any]()
        
        dic["cGoodsNo"]         = self.cGoodsNo
        dic["cGoodsName"]       = self.cGoodsName
        dic["fQuantity"]        = self.fQuantity
        dic["cUnit"]            = self.cUnit
        dic["cSpec"]            = self.cSpec
        dic["cSpuer"]           = self.cSpuer
        dic["Bidding_cSheetno"] = self.Bidding_cSheetno
        dic["cGoodsNo_State"]   = self.cGoodsNo_State
        dic["price"]            = self.price
        dic["Image_Path"]       = "\(self.cSpuer_No!)_\(self.cGoodsNo!).png"
        
        dic["cSpuer_No"]        = self.cSpuer_No
        dic["cSpuer"]           = self.cSpuer
        dic["StartTime"]        = self.StartTime
        dic["EndTime"]          = self.EndTime
        if let branchStoreList = self.branchStoreList {
            dic["branchStoreList"]  = JSON.init(parseJSON: branchStoreList).arrayObject
        } else {
             dic["branchStoreList"] = nil
        }
        return dic
    }
    
    
    
}
