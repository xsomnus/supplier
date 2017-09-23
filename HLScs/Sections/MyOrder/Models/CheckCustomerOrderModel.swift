//
//  CheckCustomerOrderModel.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/17.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import Foundation
import ObjectMapper

class CheckCustomerOrderModel:Mappable {
    
    var cStoreName:String?
    var list:[CheckCustomerListBranchModel]?
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        cStoreName <- map["cStoreName"]
        list <- map["list"]
        cStoreName <- map["Head_cStoreName"]
    }
}

class CheckCustomerListBranchModel: Mappable {
    var dDate:String?
    var Head_affirm_cSheetno:String?
    var Receiving_Way:String?
    var Head_affirm_State:String?
    
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        dDate <- map["dDate"]
        Head_affirm_cSheetno <- map["Head_affirm_cSheetno"]
        Receiving_Way <- map["Receiving_Way"]
        Head_affirm_State <- map["Head_affirm_State"]
        
    }
}







