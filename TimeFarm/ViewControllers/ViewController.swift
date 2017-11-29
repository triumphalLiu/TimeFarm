//
//  ViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        //log
    }
    
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
}

