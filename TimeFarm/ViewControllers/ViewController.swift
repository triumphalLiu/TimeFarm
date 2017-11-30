//
//  ViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    var discountTimer : Timer!
    
    @IBOutlet weak var chooseSeedButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func clickChooseSeedButton(_ sender: UIButton) {
        if(isDiscountBegin == false){
            self.performSegue(withIdentifier: "showChooseSeed", sender: nil)
        }else{
            let alertController=UIAlertController(title: "放弃专注", message: "放弃专注后，本次种植失败，并且会损失一定量的种子！", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction=UIAlertAction(title: "继续专注", style: UIAlertActionStyle.cancel, handler:nil)
            let okAction=UIAlertAction(title: "残忍放弃", style: UIAlertActionStyle.default, handler:
            {
                (alerts: UIAlertAction!) ->Void in
                self.seedFail()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated : true,completion : nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        chooseSeedButton.setTitle("选择种子", for: UIControlState.normal)
        discountTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(tickDown1s), userInfo: nil, repeats: true)
        askForNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //正确显示时间
        if(isDiscountBegin){
            if(discountTime % 60 < 10){
                timeLabel.text = String(discountTime / 60) + " : 0" + String(discountTime % 60)
            }else{
                timeLabel.text = String(discountTime / 60) + " : " + String(discountTime % 60)
            }
        }else{
            timeLabel.text = String(tomatoTime) + " : 00"
        }
    }
    
    //请求允许通知
    private func askForNotification() {
        UNUserNotificationCenter.current().getNotificationSettings {
            settings in
            switch settings.authorizationStatus {
            case .authorized:
                return
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, error) in}
            case .denied:
                DispatchQueue.main.async(execute: { () -> Void in
                    let alertController = UIAlertController(title: "消息推送已关闭", message: "打开通知能获取最新消息哦～", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
                    let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
                        (action) -> Void in
                        let url = URL(string: UIApplicationOpenSettingsURLString)
                        if let url = url, UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: {(success) in})
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    self.present(alertController, animated : true,completion : nil)
                })
            }
        }
    }
    
    //倒计时定时器方法
    @objc func tickDown1s() {
        if(isDiscountBegin){
            chooseSeedButton.setTitle("放弃专注", for: UIControlState.normal)
            discountTime = discountTime - 1
            if(discountTime % 60 < 10){
                timeLabel.text = String(discountTime / 60) + " : 0" + String(discountTime % 60)
            }else{
                timeLabel.text = String(discountTime / 60) + " : " + String(discountTime % 60)
            }
            if(discountTime == 0){
                self.seedSucc()
            }
        }
    }
    
    //种植失败
    private func seedFail() {
        isDiscountBegin = false
        self.timeLabel.text = String(tomatoTime) + " : 00"
        chooseSeedButton.setTitle("选择种子", for: UIControlState.normal)
        if(currentSeedNum == 1) {if(currentTomato > 0){currentTomato-=1}}
        else if(currentSeedNum == 2) {if(currentGrape > 0){currentGrape-=1}}
        else if(currentSeedNum == 3){if(currentWaterMelon > 0){currentWaterMelon-=1}}
        
        var msg : String = "专注失败，你本次失去了:"
        msg.append("1000块")
        let alertController=UIAlertController(title: "专注失败", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction=UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler:nil)
        alertController.addAction(okAction)
        self.present(alertController, animated : true,completion : nil)
        
        pushNotification(title: "专注失败", body: "由于你的不专心，作物已经死亡。")
        //log
    }
    
    //种植成功
    private func seedSucc() {
        isDiscountBegin = false
        self.timeLabel.text = String(tomatoTime) + " : 00"
        chooseSeedButton.setTitle("选择种子", for: UIControlState.normal)
        if(currentSeedNum == 1) {currentTomato+=1}
        else if(currentSeedNum == 2) {currentGrape+=1}
        else if(currentSeedNum == 3){currentWaterMelon+=1}
        
        var msg : String = "专注成功，你本次获得了:"
        msg.append("1000块")
        let alertController=UIAlertController(title: "专注完成", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction=UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler:nil)
        alertController.addAction(okAction)
        self.present(alertController, animated : true,completion : nil)
        //log
        
    }
    
    //推送消息
    private func pushNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let requestIdentifier = "Notification"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in}
    }
}

