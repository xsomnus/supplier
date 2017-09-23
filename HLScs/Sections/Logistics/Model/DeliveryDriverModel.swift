
//
//  DeliveryDriverModel.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/18.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import Foundation
import ObjectMapper

class DeliveryDriverModel : Mappable {
    
    var DriverNo:String?
    var TruckLicenseTag:String?
    var latitude:String?
    var Driver:String?
    var longitude:String?
    var tel:String?
    
    var position:CLLocationCoordinate2D? {
        get {
            if let latitude = latitude,
                let longitude = longitude {
            let doubleLatitude  = (latitude as NSString).doubleValue
            let doubleLongitude = (longitude as NSString).doubleValue
            return CLLocationCoordinate2D.init(latitude: doubleLatitude, longitude: doubleLongitude)
            } else {
                return nil
            }
        }
    }
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        DriverNo        <- map["DriverNo"]
        TruckLicenseTag        <- map["TruckLicenseTag"]
        latitude        <- map["latitude"]
        Driver        <- map["Driver"]
        longitude        <- map["longitude"]
        tel             <- map["tel"]
    }
}
