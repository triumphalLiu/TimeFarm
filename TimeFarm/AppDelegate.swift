//
//  AppDelegate.swift
//  TimeFarm
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataModel : DataModel = DataModel()
    
    //监听通知
    let displayStatusChanged: CFNotificationCallback = { center, observer, name, object, info in
        let str = name!.rawValue as CFString
        if (str == "com.apple.springboard.lockcomplete" as CFString) {
            let isDisplayStatusLocked = UserDefaults.standard
            isDisplayStatusLocked.set(true, forKey: "isDisplayStatusLocked")
            isDisplayStatusLocked.synchronize()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //配置disPlayStatusChanged
        let isDisplayStatusLocked = UserDefaults.standard
        isDisplayStatusLocked.set(false, forKey: "isDisplayStatusLocked")
        isDisplayStatusLocked.synchronize()
        let cfstr = "com.apple.springboard.lockcomplete" as CFString
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil, displayStatusChanged, cfstr, nil, .deliverImmediately)
        //读取数据
        dataModel.loadData()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //判断锁屏或home键
        let isDisplayStatusLocked = UserDefaults.standard
        if let lock = isDisplayStatusLocked.value(forKey: "isDisplayStatusLocked"){
            if(lock as! Bool){
                print("Lock button pressed.")
                lockTime = Date()
            }
            else{
                print("Home button pressed.")
                if(!isPaused){
                    rootVC().seedFail()
                }else{
                    lockTime = Date()
                }
            }
        }
        //保存文件
        dataModel.saveData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //重置disPlayStatusChanged
        let isDisplayStatusLocked = UserDefaults.standard
        isDisplayStatusLocked.set(false, forKey: "isDisplayStatusLocked")
        isDisplayStatusLocked.synchronize()
        
        //计算锁屏和恢复的时间差 并修改discountTime
        if(isDiscountBegin){
            resumeTime = Date()
            let dateComponentsFormatter = DateComponentsFormatter()
            dateComponentsFormatter.unitsStyle = .full
            let interval = resumeTime.timeIntervalSince(lockTime)
            dateComponentsFormatter.string(from: interval)
            print(Int(interval))
            discountTime -= Int(interval)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //种植失败
        rootVC().seedFail()
        //保存文件
        dataModel.saveData()
    }
    
    //获取rootViewController对象
    func rootVC() -> ViewController{
        let NC : UINavigationController = self.window?.rootViewController as! UINavigationController
        NC.popToRootViewController(animated: true)
        let VC : ViewController = NC.topViewController as! ViewController
        return VC
    }
}

