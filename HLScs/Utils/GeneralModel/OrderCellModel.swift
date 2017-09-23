
//
//  OrderCellModel.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/17.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderCellBranchModel:Mappable {
    var cStoreName:String?
    var cStoreNo:String?
    var fQuantity:String? {
        didSet {
            if let fQuantity = fQuantity {
                let f = (fQuantity as NSString).floatValue
                self.fQuantity = String(format: "%.2f", f)
            }
        }
    }
    var cGoodsNo:String?
    var Bidding_cSheetno:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cStoreName <- map["cStoreName"]
        cStoreNo   <- map["cStoreNo"]
        fQuantity  <- map["fQuantity"]
        cGoodsNo   <- map["cGoodsNo"]
        Bidding_cSheetno <- map["Bidding_cSheetno"]
    }
}


class OrderCellModel:Mappable {
    
    var cSpuer_No:String?
    var cSpec:String?
    var price:String? {
        didSet {
            if let price = price {
                let f = (price as NSString).floatValue
                self.price = String(format: "%.2f", f)
            }
        }
    }
    var fQuantity:String? {
        didSet {
            if let fQuantity = fQuantity {
                let f = (fQuantity as NSString).floatValue
                self.fQuantity = String(format: "%.2f", f)
            }
        }
    }
    var Image_Path:String?
    var cUnit:String?
    var StartTime:String?
    var cSpuer:String?
    var cGoodsNo:String?
    var cGoodsNo_State:String?
    var EndTime:String?
    var cGoodsName:String?
    var StoreList:[OrderCellBranchModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cSpuer_No           <- map["cSpuer_No"]
        cSpec               <- map["cSpec"]
        price               <- map["price"]
        fQuantity           <- map["fQuantity"]
        Image_Path          <- map["Image_Path"]
        cUnit               <- map["cUnit"]
        StartTime           <- map["StartTime"]
        cSpuer              <- map["cSpuer"]
        cGoodsNo            <- map["cGoodsNo"]
        cGoodsNo_State      <- map["cGoodsNo_State"]
        EndTime             <- map["EndTime"]
        cGoodsName          <- map["cGoodsName"]
        StoreList           <- map["StoreList"]
    }
}



