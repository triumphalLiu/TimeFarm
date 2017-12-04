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
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let succ : String = (isSucc) ? ("1") : ("0")
        let array : NSMutableDictionary = [:]
        array.setDictionary(log)
        array[String(currentTimes)] = [dateFormatter.string(from: date), succ, String(kind), getWhat, String(length)]
        array.write(toFile: LogPath(), atomically: true)
    }
    
    func removeLog(key : String){
        let rootDic : NSMutableDictionary! = NSMutableDictionary(contentsOfFile: LogPath())
        let path = LogPath()
        try! fileManager.removeItem(atPath: path)
        fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        rootDic!.removeObject(forKey: key)
        var i:Int = Int(key)!
        while i < currentTimes {
            let value : [String] = rootDic[String(i+1)] as! [String]
            rootDic[String(i)] = value
            rootDic!.removeObject(forKey: String(i+1))
            i += 1
        }
        currentTimes -= 1
        rootDic!.write(toFile: LogPath(), atomically: true)
    }
    
    func LogPath() -> String{
        //simulator
        //return Bundle.main.path(forResource: "historyDetail", ofType: "plist")!
        let documentDirectory: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let writableDBPath = (documentDirectory[0] as AnyObject).appendingPathComponent("/historyDetail") as String
        let dbexits = fileManager.fileExists(atPath: writableDBPath)
        if (dbexits != true) {
            let dbFile = Bundle.main.path(forResource: "historyDetail", ofType: "plist")!
            try! fileManager.copyItem(atPath: dbFile, toPath: writableDBPath)
        }
        return writableDBPath
    }
    
}
