
//
//  homeModel.swift
//  HLScs
//
//  Created by @xwy_brh on 30/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import Foundation

struct HomeVCModel {
    
    var sectionHeaderName:String?
    var sectionHeaderIcon:String?
    var childItems:[String]?

    
    public func append(arr:inout Array<HomeVCModel>){
        arr.append(self)
    }
}
