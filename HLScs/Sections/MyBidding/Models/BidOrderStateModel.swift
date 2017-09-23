//
//  BidOrderStateModel.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/19.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import ObjectMapper

class BidOrderStateModel: Mappable {

    var Bidding_State:String?
    var list:[BidOrderStateBranchModel]?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        Bidding_State <- map["Bidding_State"]
        list <- map["list"]
    }
}


class BidOrderStateBranchModel: Mappable {
    
    var dDate:String?
    var Bidding_cSheetno:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        dDate <- map["dDate"]
        Bidding_cSheetno <- map["Bidding_cSheetno"]
    }
}

