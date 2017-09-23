//
//  HLocationManager.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/18.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import CoreLocation

class HLocationManager: NSObject {

    static let sharedManager = HLocationManager.init()
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        //设置代理
        locationManager.delegate = self
        //设置定位精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
    }
    
    func startLocation() {
        //发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始...")
        }
    }
    
    //地理信息反编码
    func reverseGeocode() {
        let geocoder = CLGeocoder()
        let currentLocation = CLLocation(latitude: 32.029171, longitude: 118.788231)
        
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarkers, error) in
            //强制转成简体中文
            let array = NSArray(object: "zh-hans")
            userDefault.set(array, forKey: "AppleLanguages")
            
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print(placemarkers?.first ?? "nothing!")
            }
        }
    }
    
    //地理信息编码
    func locationEncode() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("武汉市江夏区武大科技园") { (placemarkers, error) in
            //强制转成简体中文
            let array = NSArray(object: "zh-hans")
            userDefault.set(array, forKey: "AppleLanguages")
            
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print(placemarkers?.first ?? "nothing!")
            }
        }
    }
}

extension HLocationManager:CLLocationManagerDelegate {
    
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currLocation:CLLocation = locations.last!
        print(currLocation)
    }
    
    
}









