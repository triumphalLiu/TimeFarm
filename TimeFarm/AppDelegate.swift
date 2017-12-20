//
//  AppDelegate.swift
//  TimeFarm
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //读取数据
        dataModel.loadData()
        //申请后台播放
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            try session.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print(error)
        }
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //判断锁屏或home键
        if(DidUserPressLockButton()){
            print("Lock button pressed.")
            lockTime = Date()
        }
        else{
            print("Home button pressed.")
            if(!isPaused){
                rootVC().seedFail()
            }
            else{
                lockTime = Date()
            }
        }
        //保存文件
        dataModel.saveData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //计算锁屏和恢复的时间差 并修改discountTime
        if(isDiscountBegin){
            resumeTime = Date()
            let dateComponentsFormatter = DateComponentsFormatter()
            dateComponentsFormatter.unitsStyle = .full
            let interval = resumeTime.timeIntervalSince(lockTime)
            dateComponentsFormatter.string(from: interval)
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
    
    //MARK:Apple只在用户按锁屏的时候允许程序改变applicationDidEnterBackground 模拟器无效！
    func DidUserPressLockButton() -> Bool {
        let oldBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = oldBrightness + (oldBrightness <= 0.01 ? (0.01) : (-0.01))
        return oldBrightness != UIScreen.main.brightness
    }
}

