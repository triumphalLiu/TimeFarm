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
    //保存数据
    func saveData() {
        var isNotDisturbString : String
        if(isNotDisturb){
            isNotDisturbString = "1"
        }else{
            isNotDisturbString = "0"
        }
        let array : NSDictionary = [
            "tomatoTime": String(tomatoTime),
            "isNotDisturb": isNotDisturbString,
            "currentCity": currentCity,
            "currentSeedNum": String(currentSeedNum),
            "currentTomato": String(currentTomato),
            "currentGrape": String(currentGrape),
            "currentWaterMelon": String(currentWaterMelon)
        ]
        array.write(toFile: dataFilePath(), atomically: true)
    }
    
    //读取数据
    func loadData() {
        let dic = NSDictionary(contentsOfFile: dataFilePath()) as! [String: String]
        for(key, value) in dic{
            switch key{
            case "tomatoTime": tomatoTime = Int(value)!
                break
            case "isNotDisturb":
                if Int(value) == 0{
                    isNotDisturb = false
                }else{
                    isNotDisturb = true
                }
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
            default:
                break
            }
        }
    }
    
    //文件路径
    func dataFilePath()->String{
        return Bundle.main.path(forResource: "userList", ofType: "plist")!
    }
}
