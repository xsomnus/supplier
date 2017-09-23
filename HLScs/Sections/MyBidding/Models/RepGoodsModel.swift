
//
//  RepGoodsModel.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import ObjectMapper


class RepGoodsModel:Mappable {
    
    var cSheetno:String?
    var cStoreName: String?
    var fQty: String? {
        didSet {
            if let fQty = fQty {
                let f = (fQty as NSString).floatValue
                self.fQty = String(format: "%.2f", f)
            }
        }
    }
    var cUnit:String?
    var cGoodsNo:String?
    var cGoodsName:String?
    var cSpec:String?
    var Store_Request_list:[BranchStoreRepModel]?
    
    required init?(map: Map) {
        
    }
    
    public init?(JSON: [String: Any], context: MapContext? = nil) {
        
    }
    
    func mapping(map: Map) {
        cSheetno    <- map["cSheetno"]
        cStoreName  <- map["cStoreName"]
        fQty        <- map["fQty"]
        cUnit       <- map["cUnit"]
        cGoodsNo    <- map["cGoodsNo"]
        cGoodsName  <- map["cGoodsName"]
        cSpec       <- map["cSpec"]
        Store_Request_list <- map["Store_Request_list"]
    }
    
}


