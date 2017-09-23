//
//  BranchStoreRepModel.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import ObjectMapper
class BranchStoreRepModel: Mappable {

    var cStoreName:String?
    var fQty:String? {
        didSet {
            if let fQty = fQty {
                let f = (fQty as NSString).floatValue
                self.fQty = String(format: "%.2f", f)
            }
        }
    }
    var cGoodsNo:String?
    var cStoreNo:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cStoreName <- map["cStoreName"]
        fQty       <- map["fQty"]
        cGoodsNo   <- map["cGoodsNo"]
        cStoreNo   <- map["cStoreNo"]
    }
    
    func beDict() -> Dictionary<String, Any> {
        var dic = [String:Any]()
        dic["cStoreName"]      = self.cStoreName
        if let fQty = self.fQty {
            dic["fQuantity"]   = fQty
        }
        dic["cGoodsNo"]        = self.cGoodsNo
        dic["cStoreNo"]        = self.cStoreNo
        return dic
    }
    
}
