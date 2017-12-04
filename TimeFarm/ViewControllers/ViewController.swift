//
//  ViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
import UserNotifications
import MapKit

class ViewController: UIViewController {
    
    var discountTimer : Timer!
    var urlSession = URLSession.shared
    
    @IBOutlet weak var chooseSeedButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func clickChooseSeedButton(_ sender: UIButton) {
        if(isDiscountBegin == false){
            self.performSegue(withIdentifier: "showChooseSeed", sender: nil)
        }else{
            let alertController=UIAlertController(title: "放弃专注", message: "放弃专注后，本次种植失败，并且会损失一定量的种子！", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction=UIAlertAction(title: "继续专注", style: UIAlertActionStyle.cancel, handler:nil)
            let okAction=UIAlertAction(title: "残忍放弃", style: UIAlertActionStyle.destructive, handler:
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
        if(isDiscountBegin && discountTime >= 0){
            if(discountTime % 60 < 10){
                timeLabel.text = String(discountTime / 60) + " : 0" + String(discountTime % 60)
            }else{
                timeLabel.text = String(discountTime / 60) + " : " + String(discountTime % 60)
            }
        }else{
            timeLabel.text = String(tomatoTime) + " : 00"
        }
        //保存结果
        dataModel.saveData()
        //更新天气
        loadWeather()
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
            if(discountTime <= 0){
                self.seedSucc()
            }
            else{
                if(discountTime % 60 < 10){
                    timeLabel.text = String(discountTime / 60) + " : 0" + String(discountTime % 60)
                }else{
                    timeLabel.text = String(discountTime / 60) + " : " + String(discountTime % 60)
                }
            }
        }
    }
    
    //种植失败
    func seedFail() {
        if(isDiscountBegin){
            isDiscountBegin = false
            self.timeLabel.text = String(tomatoTime) + " : 00"
            chooseSeedButton.setTitle("选择种子", for: UIControlState.normal)
            
            var msg : String = "专注失败，你本次失去了:"
            if(currentSeedNum == 0) {
                if(currentTomato > 1){
                    currentTomato-=2
                    msg.append("🍅×2")
                }
                else if(currentTomato == 1){
                    currentTomato-=1
                    msg.append("🍅×1")
                }
                else{
                    msg.removeAll()
                    msg = "专注失败，家徒四壁没有什么好失去的了。"
                }
            }
            else if(currentSeedNum == 1) {
                if(currentGrape > 1){
                    currentGrape-=2
                    msg.append("🍇×2")
                }
                else if(currentGrape == 1){
                    currentGrape-=1
                    msg.append("🍇×1")
                }else{
                    currentTomato-=2
                    msg.append("🍅×2")
                }
            }
            else if(currentSeedNum == 2){
                if(currentWaterMelon > 1){
                    currentWaterMelon-=2
                    msg.append("🍉×2")
                }
                else if(currentWaterMelon == 1){
                    currentWaterMelon-=1
                    msg.append("🍉×1")
                }else{
                    currentGrape-=2
                    msg.append("🍇×2")
                }
            }
            
            let alertController=UIAlertController(title: "专注失败", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            let okAction=UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler:nil)
            alertController.addAction(okAction)
            self.present(alertController, animated : true,completion : nil)
            
            pushNotification(title: "专注失败", body: "由于你的不专心，作物已经死亡。")
            //log
            dataModel.saveData()
            currentTimes += 1
            logModel.saveLog(date: startTime, getWhat: msg, isSucc: false, length: thisTime, kind: currentSeedNum)
        }
    }
    
    //种植成功
    func seedSucc() {
        isDiscountBegin = false
        self.timeLabel.text = String(tomatoTime) + " : 00"
        chooseSeedButton.setTitle("选择种子", for: UIControlState.normal)
        
        var msg : String = "专注成功，你本次获得了:"
        if(currentSeedNum == 0) {
            currentTomato+=1
            msg.append("🍅×1")
        }
        else if(currentSeedNum == 1) {
            currentGrape+=1
            msg.append("🍇×1")
        }
        else if(currentSeedNum == 2){
            currentWaterMelon+=1
            msg.append("🍉×1")
        }
        
        let alertController=UIAlertController(title: "专注完成", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction=UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler:nil)
        alertController.addAction(okAction)
        self.present(alertController, animated : true,completion : nil)
        //log
        dataModel.saveData()
        currentTimes += 1
        logModel.saveLog(date: startTime, getWhat: msg, isSucc: true, length: thisTime, kind: currentSeedNum)
    }
    
    //推送消息
    private func pushNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let requestIdentifier = "Notification"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in}
    }
    
    //加载天气
    private func loadWeather() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(currentCity, completionHandler: {
            (placemarks:[CLPlacemark]?, error:Error?) -> Void in
            if error != nil {
                currentTemp = "N/A"
                currentWeather = 0
                return
            }
            if let p = placemarks?[0]{
                print("经度：\(p.location!.coordinate.longitude)" + "纬度：\(p.location!.coordinate.latitude)")
                //Example url: api.openweathermap.org/data/2.5/weather?lat=35&lon=139
                let apiKEY = "69f11f0bb83fe18a7ff855d7a4c8ba49"
                let urlStr = "http://api.openweathermap.org/data/2.5/weather?lat=\(p.location!.coordinate.latitude)&lon=\(p.location!.coordinate.longitude)&appid=\(apiKEY)"
                let url = NSURL(string: urlStr)!
                guard let weatherData = NSData(contentsOf: url as URL) else { return }
                let jsonData = try! JSON(data: weatherData as Data)
                let weather = jsonData["weather"][0]["main"].string!
                print(weather)
                switch weather {
                case "Clear": currentWeather = 0 //晴天
                    break
                case "Clouds": currentWeather = 1 
                    break
                case "Rain": currentWeather = 2
                    break
                case "Snow": currentWeather = 2
                    break
                case "Wind": currentWeather = 1
                    break
                case "Haze": currentWeather = 0
                    break
                case "Mist": currentWeather = 1
                    break
                default: currentWeather = 0
                    break
                }
                let temp = jsonData["main"]["temp"].number!
                currentTemp = String(Int(truncating: temp) - 273) + "°C"
            } else {
                currentTemp = "N/A"
                currentWeather = 0
            }
        })
    }
}

