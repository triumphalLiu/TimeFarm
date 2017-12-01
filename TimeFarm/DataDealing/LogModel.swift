//
//  SeedLog.swift
//  TimeFarm
//
//  Created by apple on 2017/12/1.
//  Copyright © 2017年 liu. All rights reserved.
//

import Foundation

class LogModel {
    
    let fileManager = FileManager.default
    
    func readLog() -> [String:[String]]{
        let data = NSDictionary(contentsOfFile: LogPath()) as! [String:[String]]
        return data
    }
    
    func saveLog(date: Date, getWhat: String, isSucc: Bool, length: Int, kind: Int) {
        let log = readLog()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        let succ : String = (isSucc) ? ("1") : ("0")
        let array : NSMutableDictionary = [:]
        array.setDictionary(log)
        array[String(currentTimes)] = [dateFormatter.string(from: date), succ, String(kind), getWhat, String(length)]
        array.write(toFile: LogPath(), atomically: true)
    }
    
    func LogPath() -> String{
        return Bundle.main.path(forResource: "historyDetail", ofType: "plist")!
    }
    
}
