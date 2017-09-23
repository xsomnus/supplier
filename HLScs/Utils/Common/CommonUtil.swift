//
//  Constant.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 08/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//


import UIKit
import SnapKit
import Moya
import Alamofire
import SwiftyJSON


//Mark: 定义一些常用的闭包
typealias ClosureVoid_Void = ()->Void
typealias ClosureVoid_Int = ()->Int
typealias ClosureVoid_String = ()->String
typealias ClosureVoid_Tuple = ()->(value1 : String, value2 : String)
typealias ClosureInt_Void = (_ num:Int)->Void
typealias ColsureBool_Void = (_ result:Bool) ->Void

//Mark: -- Documents文件路径
let DocumentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString

//Mark: -- 使用userDefault进行轻量级的本地数据的读取/删除操作
let userDefault = UserDefaults.standard

//Mark: --- UserDefault数据持久化
let userDefaultUserIDKey = "userDefaultUserIDKey"
let HOME_CHILDVCS = "HOME_CHILDVCS"

//Mark: -- 通知中心的使用, 用来定义通知的名称
let NotifyUpdateCategory = NSNotification.Name(rawValue:"notifyUpdateCategory")

//Mark: --- 每次提交竞价单之后的通知名称
let NotifyUploadBidOrder = NSNotification.Name(rawValue:"KNotifyUploadBidOrder")
let NotifyStockFinished = NSNotification.Name(rawValue:"KNotifyStockFinished")
//Mark: -- iOS开发过程中常用的一些的布局常量
let kStatusBarH: CGFloat = 20
let kNavigationBarH: CGFloat = 44
let kTabBarH: CGFloat = 49
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height

let kSumStatuNavH = kStatusBarH + kNavigationBarH
let kSubStatuNavH = kScreenW - kSumStatuNavH

let WID = kScreenW/20
let HEI = kScreenH/20
let kGoldRatio:CGFloat = 0.618



//Mark: -- 获取当前时间
func getDate() -> String {
    let date = Date()
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}


//Mark: -- 字体大小函数
func font(_ a:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: a)
}

/// Mark: -- 延迟执行
///
/// - Parameters:
///   - delay: 延迟时间
///   - blok: 延迟执行的闭包
func DispatchQueue_AfterExecute(delay:Double, blok:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: blok)
}


/// Mark: -- plist文件路径
///
/// - Parameter filename: plist名字
/// - Returns: 返回plist文件所在的路径
func SavePlistfilename(filename:String) -> String {
    return (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(filename)
}










