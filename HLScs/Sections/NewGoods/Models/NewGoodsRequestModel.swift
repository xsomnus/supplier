//
//  NewGoodsRequestModel.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import Foundation
import ObjectMapper

class NewGoodsRequestModel : Mappable {
    var cSupNo:String?
    var Applicant:String?
    var Tel:String?
    var Image_Path:String?
    var dDate:String?
    var cUnit:String?
    var cSpec:String?
    var Price:String?
    var cBarcode:String?
    var num:String?
    var cGoodsName:String?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        cSupNo <- map["cSupNo"]
        Applicant <- map["Applicant"]
        Tel <- map["Tel"]
        Image_Path <- map["Image_Path"]
        dDate <- map["dDate"]
        cUnit <- map["cUnit"]
        cSpec <- map["cSpec"]
        Price <- map["Price"]
        cBarcode <- map["cBarcode"]
        num <- map["num"]
        cGoodsName <- map["cGoodsName"]
        
    }
}
