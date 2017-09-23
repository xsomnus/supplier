//
//  ObjectMapper+MoyaResponse.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import SwiftyJSON

extension Response {
    public func mapObject<T: BaseMappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
    public func mapArray<T: BaseMappable>(_ type: T.Type) throws -> [T] {
        let json = JSON(data: self.data)
        let jsonArray = json["dDate"]
        print(json)
        
        guard let array = jsonArray.arrayObject as? [[String: Any]],
            let objects = Mapper<T>().mapArray(JSONArray: array) else {
                throw MoyaError.jsonMapping(self)
        }
        return objects
    }
}
