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
import MediaPlayer

class ViewController: UIViewController {
    
    //定时器 1s 用于倒计时
    var discountTimer : Timer!
    
    @IBOutlet weak var chooseSeedButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func clickChooseSeedButton(_ sender: UIButton) {
        if(isDiscountBegin == false){
            self.performSegue(withIdentifier: "showChooseSeed", sender: nil)
        }
        else{
            let alertController=UIAlertController(title: "放弃专注",
                                                  message: "放弃专注后，本次种植失败，并且会损失一定量的种子！", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction=UIAlertAction(title: "继续专注",
                                           style: UIAlertActionStyle.cancel, handler:nil)
            let okAction=UIAlertAction(title: "残忍放弃",
                                       style: UIAlertActionStyle.destructive, handler:
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
        discountTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1),
                                             target: self, selector: #selector(tickDown1s), userInfo: nil, repeats: true)
        askForNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //第一次打开应用
        if (!(UserDefaults.standard.bool(forKey: "everLaunched"))) {
            let guide = GuideViewController()
            self.present(guide, animated: true, completion: nil)
        }
        //正确显示时间
        if(isDiscountBegin && discountTime >= 0){
            if(discountTime % 60 < 10){
                timeLabel.text = String(discountTime / 60) + " : 0" + String(discountTime % 60)
            }
            else{
                timeLabel.text = String(discountTime / 60) + " : " + String(discountTime % 60)
            }
        }
        else{
            timeLabel.text = String(tomatoTime) + " : 00"
        }
        //保存结果
        dataModel.saveData()
        //如果城市发生了改变 就更新天气
        if(lastCity != currentCity){
            loadWeather()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lastCity = currentCity
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
                    let alertController = UIAlertController(title: "消息推送已关闭",
                                                            message: "打开通知能获取最新消息哦～", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
                    let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
                        (action) -> Void in
                        let url = URL(string: UIApplicationOpenSettingsURLString)
                        if let url = url, UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url, options: [:],
                                                          completionHandler: {(success) in})
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
                }
                else{
                    timeLabel.text = String(discountTime / 60) + " : " + String(discountTime % 60)
                }
            }
        }
    }
    
    //种植失败
    func seedFail() {
        if(isDiscountBegin){
            //振动
            let soundID = SystemSoundID(kSystemSoundID_Vibrate)
            AudioServicesPlaySystemSound(soundID)
            //其他
            musicModel.playStop()
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
                }
                else{
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
                }
                else{
                    currentGrape-=2
                    msg.append("🍇×2")
                }
            }
            
            ZuberAlert().showAlert(title: "专注失败", subTitle: msg, buttonTitle: "确定", otherButtonTitle: nil) {
                (OtherButton) -> Void in
                print("OK")
            }
            
            pushNotification(title: "专注失败", body: "由于你的不专心，作物已经死亡。")
            //log
            dataModel.saveData()
            currentTimes += 1
            logModel.saveLog(date: startTime, getWhat: msg,
                             isSucc: false, length: thisTime, kind: currentSeedNum)
        }
    }
    
    //种植成功
    func seedSucc() {
        musicModel.playStop()
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
        
        ZuberAlert().showAlert(title: "专注成功", subTitle: msg, buttonTitle: "确定", otherButtonTitle: nil) {
            (OtherButton) -> Void in
            print("OK")
        }
        //log
        dataModel.saveData()
        currentTimes += 1
        logModel.saveLog(date: startTime, getWhat: msg,
                         isSucc: true, length: thisTime, kind: currentSeedNum)
    }
    
    //推送消息
    private func pushNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let requestIdentifier = "Notification"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in}
    }
    
    //查看天气
    @IBAction func showWeather(_ sender: UIButton) {
        var content : String = ""
        print(allWeatherInfo)
        if(allWeatherInfo == nil){
            ZuberAlert().showAlert(title: "网络出问题啦", subTitle: "请检查网络", buttonTitle: "确定", otherButtonTitle: nil) {
                (OtherButton) -> Void in
                print("OK")
            }
            return
        }
        content.append("城市:\(currentCity)\n")
        content.append("详细天气:\(allWeatherInfo["weather"][0]["description"].string!)\n")
        content.append("温度:\(Int(truncating: allWeatherInfo["main"]["temp"].number!) - 273)°C\n")
        content.append("湿度:\(allWeatherInfo["main"]["humidity"].number!)%\n")
        content.append("气压:\(allWeatherInfo["main"]["pressure"].number!)hPa\n")
        content.append("风速:\(allWeatherInfo["wind"]["speed"].number!)m/s\n")
        ZuberAlert().showAlert(title: "天气详情", subTitle: content, buttonTitle: "确定", otherButtonTitle: "复制") {
            (OtherButton) -> Void in
            print("OK")
        }
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
                //Example url: api.openweathermap.org/data/2.5/weather?lat=35&lon=139
                let apiKEY = "69f11f0bb83fe18a7ff855d7a4c8ba49"
                let urlStr = "http://api.openweathermap.org/data/2.5/weather?lat=\(p.location!.coordinate.latitude)&lon=\(p.location!.coordinate.longitude)&appid=\(apiKEY)"
                let url = NSURL(string: urlStr)!
                guard let
                    weatherData = NSData(contentsOf: url as URL)
                    else {
                        return
                    }
                print(weatherData)
                let jsonData : JSON
                do {
                    try jsonData = JSON(data: weatherData as Data)
                    allWeatherInfo = jsonData
                }catch{
                    print("error")
                    return
                }
                print(jsonData)
                let weather = jsonData["weather"][0]["main"].string!
                print(weather)
                switch weather {
                case "Clear":
                    currentWeather = 0 //晴天
                    break
                case "Clouds":
                    currentWeather = 1
                    break
                case "Rain":
                    currentWeather = 2
                    break
                case "Snow":
                    currentWeather = 2
                    break
                case "Wind":
                    currentWeather = 1
                    break
                case "Haze":
                    currentWeather = 0
                    break
                case "Mist":
                    currentWeather = 1
                    break
                default:
                    currentWeather = 0
                    break
                }
                let temp = jsonData["main"]["temp"].number!
                currentTemp = String(Int(truncating: temp) - 273) + "°C"
            }
            else {
                currentTemp = "N/A"
                currentWeather = 0
            }
        })
    }
}

