//
//  SQLManager.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SQLite

//Mark: --- 数据库名称

//Mark: --- 创建保存竞价的商品数据库表的表名
let bidGoodsTable:String = "kbidGoodsTable"


class SQLManager: NSObject {

    static let shareSQLManager = SQLManager.init()
    
    var db:Connection?
    var bidGoodsTableObj:Table?
    
    override init() {
        super.init()
        do {
           self.db  = try Connection("\(DocumentsPath)/db.sqlite3")
            print("\(DocumentsPath)/db.sqlite3")
            createTable()
        } catch {
            
        }
    }
    
    //创建字段
    let id = Expression<Int64>("id")
    let cGoodsNo = Expression<String?>("cGoodsNo")
    let cGoodsName = Expression<String?>("cGoodsName")
    let fQuantity = Expression<String?>("fQuantity")
    let cUnit = Expression<String?>("cUnit")
    let cSpec = Expression<String?>("cSpec")
    let Bidding_cSheetno = Expression<String?>("Bidding_cSheetno")
    let cGoodsNo_State = Expression<String?>("cGoodsNo_State")
    let price = Expression<String?>("price")
    let Image_Path = Expression<String?>("Image_Path")
    let cSpuer_No = Expression<String?>("cSpuer_No")
    let cSpuer = Expression<String?>("cSpuer")
    let StartTime = Expression<String?>("StartTime")
    let EndTime = Expression<String?>("EndTime")
    let branchStoreList = Expression<String?>("branchStoreList")
    
    func createTable() {
        do {
            let bidgoodsTable = Table("kbidGoodsTable")
            self.bidGoodsTableObj = bidgoodsTable
           
            
            try self.db?.run(bidgoodsTable.create{t in
                t.column(id, primaryKey: true)
                t.column(cGoodsNo)
                t.column(cGoodsName)
                t.column(fQuantity)
                t.column(cUnit)
                t.column(cSpec)
                t.column(Bidding_cSheetno)
                t.column(cGoodsNo_State)
                t.column(price)
                t.column(Image_Path)
                t.column(cSpuer_No)
                t.column(cSpuer)
                t.column(StartTime)
                t.column(EndTime)
                t.column(branchStoreList)
            })
        } catch {
            
        }
    }
 
    
    func insertModel(model:BidGoodsInfoModel) -> Int64? {
        if let bidTable = self.bidGoodsTableObj {
           let insert = bidTable.insert(cGoodsNo <- model.cGoodsNo, cGoodsName <- model.cGoodsName, fQuantity <- model.fQuantity, cUnit <- model.cUnit, cSpec <- model.cUnit, Bidding_cSheetno <- model.Bidding_cSheetno, cGoodsNo_State <- model.cGoodsNo_State, price <- model.price, Image_Path <- model.Image_Path, cSpuer_No <- model.cSpuer_No, cSpuer <- model.cSpuer, StartTime <- model.StartTime, EndTime <- model.EndTime, branchStoreList <- model.branchStoreList)
            do {
                let rowid = try self.db?.run(insert)
                if let rowid = rowid {
                    print(rowid)
                    print("插入\(model.cGoodsName!)成功")
                }
                return rowid
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func selectBidGoodsModel() ->[BidGoodsInfoModel]? {
        if let bidTable = self.bidGoodsTableObj {
            do {
                var tmpArr = [BidGoodsInfoModel]()
                for dbModel in try db!.prepare(bidTable) {
                    let newModel = BidGoodsInfoModel.init()
                    newModel.cUnit            = dbModel[cUnit]
                    newModel.Bidding_cSheetno = dbModel[Bidding_cSheetno]
                    newModel.cGoodsNo         = dbModel[cGoodsNo]
                    newModel.cGoodsName       = dbModel[cGoodsName]
                    newModel.fQuantity        = dbModel[fQuantity]
                    newModel.cSpec            = dbModel[cSpec]
                    newModel.cGoodsNo_State   = dbModel[cGoodsNo_State]
                    newModel.price            = dbModel[price]
                    newModel.Image_Path       = dbModel[Image_Path]
                    newModel.cSpuer_No        = dbModel[cSpuer_No]
                    newModel.cSpuer           = dbModel[cSpuer]
                    newModel.StartTime        = dbModel[StartTime]
                    newModel.EndTime          = dbModel[EndTime]
                    newModel.branchStoreList  = dbModel[branchStoreList]
                    tmpArr.append(newModel)
                }
                return tmpArr
            } catch {
                return nil
            }
        }
        return nil
    }
    
    //Mark: --- 根据对应的单号查询数据
    func selectBidGoodsModelWith(cSheetNo:String) ->[BidGoodsInfoModel]? {
        if let bidTable = self.bidGoodsTableObj {
            do {
                var tmpArr = [BidGoodsInfoModel]()
                for dbModel in try db!.prepare(bidTable.filter(Bidding_cSheetno == cSheetNo)) {
                    let newModel = BidGoodsInfoModel.init()
                    newModel.cUnit            = dbModel[cUnit]
                    newModel.Bidding_cSheetno = dbModel[Bidding_cSheetno]
                    newModel.cGoodsNo         = dbModel[cGoodsNo]
                    newModel.cGoodsName       = dbModel[cGoodsName]
                    newModel.fQuantity        = dbModel[fQuantity]
                    newModel.cSpec            = dbModel[cSpec]
                    newModel.cGoodsNo_State   = dbModel[cGoodsNo_State]
                    newModel.price            = dbModel[price]
                    newModel.Image_Path       = dbModel[Image_Path]
                    newModel.cSpuer_No        = dbModel[cSpuer_No]
                    newModel.cSpuer           = dbModel[cSpuer]
                    newModel.StartTime        = dbModel[StartTime]
                    newModel.EndTime          = dbModel[EndTime]
                    newModel.branchStoreList  = dbModel[branchStoreList]
                    tmpArr.append(newModel)
                }
                return tmpArr
            } catch {
                return nil
            }
        }
        return nil
        
    }
    
    
    func deleteDBWith(cSheetNo:String) {
        if let bidTable = self.bidGoodsTableObj {
            do {
                try self.db?.run(bidTable.filter(Bidding_cSheetno == cSheetNo).delete())
                print("删除成功!")
            } catch {
                print("删除失败!")
            }
        }
    }
    
    //Mark: --- 查询有多少个单号集合(INT类型的数组)
    func selectCSheetNoTypeCounts() -> [Int]? {
        var cSheetNoArr = [Int]()
        if let bidTable = self.bidGoodsTableObj {
            do {
                for dbModel in  try db!.prepare(bidTable) {
                    print(dbModel[Bidding_cSheetno] ?? "nilllli")
                    if let Bidding_cSheetno = dbModel[Bidding_cSheetno] {
                        let no = (Bidding_cSheetno as NSString).integerValue
                        cSheetNoArr.append(no)
                    }
                }
                
                return Array(Set(cSheetNoArr)).sorted()
            } catch {
                print("查询出错!")
                return nil 
            }
            
        } else  {
            return nil
        }
    }
    
    
    //Mark: --- 查询有多少个商家
    
}





