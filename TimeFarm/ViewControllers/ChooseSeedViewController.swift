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
    @IBOutlet weak var TimeTextField: UITextField!
    var pickerView : UIPickerView! = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        TimeTextField.text = String(tomatoTime) + " : 00"
        setSeedPicView.image = UIImage(named: seedList[currentSeedNum])
        if(currentSeedNum == 0){
            chooseLast.isEnabled  = false
        }
        else{
            chooseLast.isEnabled  = true
        }
        if(currentSeedNum == 2){
            chooseNext.isEnabled  = false
        }
        else{
            chooseNext.isEnabled  = true
        }
        loadPickerView()
        checkUnlock()
    }
    
    private func checkUnlock(){
        if(currentSeedNum == 0){
            unlockLabel.text = "已解锁"
            needLabel.text = ""
            startButton.isEnabled = true
        }
        else if(currentSeedNum == 1){
            if(currentTomato >= 100){
                unlockLabel.text = "已解锁"
                needLabel.text = ""
                startButton.isEnabled = true
            }
            else{
                unlockLabel.text = "未解锁"
                needLabel.text = "还需" + String(100 - currentTomato) + "颗番茄即可解锁"
                startButton.isEnabled = false
            }
        }
        else if(currentSeedNum == 2){
            if(currentGrape >= 100){
                unlockLabel.text = "已解锁"
                needLabel.text = ""
                startButton.isEnabled = true
            }
            else{
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
        thisTime = tomatoTime
        startTime = Date()
        self.navigationController?.popViewController(animated: true)
        //播放声音
        if(isPlaySound != 0){
            musicModel.playSound(which: currentWeather)
        }
    }
    
    @IBAction func changeTime(_ sender: Any) {
    }
    
    //toolbar按钮事件
    @objc func clickOKButton() {
        tomatoTime = self.pickerView.selectedRow(inComponent: 0) * 5 + 5
        TimeTextField.text = String(tomatoTime) + " : 00"
        TimeTextField.resignFirstResponder()
    }
    
    @objc func clickCancelButton() {
        TimeTextField.text = String(tomatoTime) + " : 00"
        TimeTextField.resignFirstResponder()
    }
    
    private func loadPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow((tomatoTime-5)/5, inComponent : 0, animated: true)
        let pickerViewOKButton : UIBarButtonItem = UIBarButtonItem(title: "完成",
                                                                   style: .done, target: self, action: #selector(clickOKButton))
        let pickerViewSpace : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let pickerViewCancelButton : UIBarButtonItem = UIBarButtonItem(title: "取消",
                                                                       style: .done, target: self, action: #selector(clickCancelButton))
        let pickerViewToolBar : UIToolbar = UIToolbar()
        var toolBarButtons : [UIBarButtonItem] = []
        toolBarButtons.append(pickerViewCancelButton)
        toolBarButtons.append(pickerViewSpace)
        toolBarButtons.append(pickerViewOKButton)
        pickerViewToolBar.items = toolBarButtons
        pickerViewToolBar.sizeToFit()
        TimeTextField.inputView = pickerView
        TimeTextField.inputAccessoryView = pickerViewToolBar
    }
}

extension ChooseSeedViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 15
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row*5+5)+"分钟"
    }
}
