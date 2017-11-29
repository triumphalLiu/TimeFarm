//
//  ChooseSeedViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
class ChooseSeedViewController:UIViewController{
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var unlockLabel: UILabel!
    @IBOutlet weak var needLabel: UILabel!
    @IBOutlet weak var chooseNext: UIButton!
    @IBOutlet weak var chooseLast: UIButton!
    @IBOutlet weak var setSeedPicView: UIImageView!
    @IBOutlet weak var setTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimeLabel.text = String(tomatoTime) + " : 00"
        setSeedPicView.image = UIImage(named: seedList[currentSeedNum])
        if(currentSeedNum == 0){
            chooseLast.isEnabled  = false
        }else{
            chooseLast.isEnabled  = true
        }
        if(currentSeedNum == 2){
            chooseNext.isEnabled  = false
        }else{
            chooseNext.isEnabled  = true
        }
        checkUnlock()
    }
    
    private func checkUnlock(){
        if(currentSeedNum == 0){
            unlockLabel.text = "已解锁"
            needLabel.text = ""
            startButton.isEnabled = true
        }else if(currentSeedNum == 1){
            if(currentTomato >= 100){
                unlockLabel.text = "已解锁"
                needLabel.text = ""
                startButton.isEnabled = true
            }else{
                unlockLabel.text = "未解锁"
                needLabel.text = "还需" + String(100 - currentTomato) + "颗番茄即可解锁"
                startButton.isEnabled = false
            }
        }else if(currentSeedNum == 2){
            if(currentGrape >= 100){
                unlockLabel.text = "已解锁"
                needLabel.text = ""
                startButton.isEnabled = true
            }else{
                unlockLabel.text = "未解锁"
                needLabel.text = "还需" + String(100 - currentGrape) + "株葡萄即可解锁"
                startButton.isEnabled = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func clickChooseNext(_ sender: UIButton) {
        chooseLast.isEnabled  = true
        currentSeedNum = currentSeedNum + 1
        setSeedPicView.image = UIImage(named: seedList[currentSeedNum])
        if(currentSeedNum == 2){
            chooseNext.isEnabled  = false
        }
        checkUnlock()
    }
    
    @IBAction func clickChooseLast(_ sender: UIButton) {
        chooseNext.isEnabled  = true
        currentSeedNum = currentSeedNum - 1
        setSeedPicView.image = UIImage(named: seedList[currentSeedNum])
        if(currentSeedNum == 0){
            chooseLast.isEnabled  = false
        }
        checkUnlock()
    }
    
    @IBAction func clickBeginDiscount(_ sender: UIButton) {
        isDiscountBegin = true
        discountTime = tomatoTime * 60
        self.navigationController?.popViewController(animated: true)
    }
}
