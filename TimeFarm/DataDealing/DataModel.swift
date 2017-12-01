//
//  DataModel.swift
//  TimeFarm
//
//  Created by apple on 2017/11/29.
//  Copyright © 2017年 liu. All rights reserved.
//

import Foundation
import UIKit

class DataModel: NSObject{
    
    //以下为用户配置文件的读取
    let fileManager = FileManager()
    
    //保存数据
    func saveData() {
        let curT = String(currentTimes)
        let array : NSDictionary = [
            "tomatoTime": String(tomatoTime),
            "currentCity": currentCity,
            "currentSeedNum": String(currentSeedNum),
            "currentTomato": String(currentTomato),
            "currentGrape": String(currentGrape),
            "currentWaterMelon": String(currentWaterMelon),
            "currentTimes": curT]
        array.write(toFile: dataFilePath(), atomically: true)
    }
    
    //读取数据
    func loadData() {
        let dic = NSDictionary(contentsOfFile: dataFilePath()) as! [String: String]
        for(key, value) in dic{
            switch key{
            case "tomatoTime": tomatoTime = Int(value)!
                break
            case "currentCity": currentCity = value
                break
            case "currentSeedNum": currentSeedNum = Int(value)!
                break
            case "currentTomato": currentTomato = Int(value)!
                break
            case "currentGrape": currentGrape = Int(value)!
                break
            case "currentWaterMelon": currentWaterMelon = Int(value)!
                break
            case "currentTimes": currentTimes = Int(value)!
            default:
                break
            }
        }
    }
    
    //文件路径
    func dataFilePath()->String{
        //simulator
        //return Bundle.main.path(forResource: "userList", ofType: "plist")!
        //取沙盒里plist文件
        let documentDirectory: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let writableDBPath = (documentDirectory[0] as AnyObject).appendingPathComponent("/userList") as String
        //判断沙盒的appData.plist文件是否存在,不存在则从资源目录复制一份
        let dbexits = fileManager.fileExists(atPath: writableDBPath)
        print(dbexits)
        if (dbexits != true) {
            let dbFile = Bundle.main.path(forResource: "userList", ofType: "plist")!
            try! fileManager.copyItem(atPath: dbFile, toPath: writableDBPath)
        }
        return writableDBPath
    }
}
