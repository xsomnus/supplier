//
//  GridTVGoodsModel.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/11.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class GridTVGoodsModel: NSObject {

    var cGoodsName = ""
    var cGoodsNo = ""
    var cTotalRequest = ""
    var cUint = ""
    /*
 
     "cStoreName" : "合计",
     "fQty" : "8.0000",
     "cUnit" : "斤",
     "Store_Request_list" : [
     {
     "cStoreName" : "福新店1001",
     "fQty" : "8.0000",
     "cGoodsNo" : "01013"
     }
     ],
     "cGoodsNo" : "01013",
     "cGoodsName" : "白玉菇"
    */
    
    var cImagesArr = [String]() //Mark: --- 海报图地址数组
    var cGoodsPrice = ""        //Mark: --- 商品竞价单价
    
    init(dic:[String:Any]?) {
        super.init()
        if let dic = dic {
            self.setValuesForKeys(dic)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
