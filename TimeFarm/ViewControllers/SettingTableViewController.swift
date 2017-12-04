//
//  settingTableViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/11/25.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
class SettingTableViewController:UITableViewController{
    
    @IBOutlet weak var playSwitch: UISwitch!
    @IBOutlet weak var notdisturbButton: UISwitch!
    @IBOutlet weak var pauseButton: UISwitch!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    var pickerView : UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        timeTextField.text = String(tomatoTime) + "分钟"
        cityLabel.text = currentCity
        notdisturbButton.isOn = isNotDisturb
        pauseButton.isOn = isPaused
        if(isPlaySound == 0){
            playSwitch.isOn = false
        }else{
            playSwitch.isOn = true
        }
    }
    
    //单击选择时间事件
    @IBAction func startSettingTime(_ sender: UITextField) {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow((tomatoTime-5)/5, inComponent : 0, animated: true)
        let pickerViewOKButton : UIBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(clickOKButton))
        let pickerViewSpace : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let pickerViewCancelButton : UIBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(clickCancelButton))
        let pickerViewToolBar : UIToolbar = UIToolbar()
        var toolBarButtons : [UIBarButtonItem] = []
        toolBarButtons.append(pickerViewCancelButton)
        toolBarButtons.append(pickerViewSpace)
        toolBarButtons.append(pickerViewOKButton)
        pickerViewToolBar.items = toolBarButtons
        pickerViewToolBar.sizeToFit()
        timeTextField.inputView = pickerView
        timeTextField.inputAccessoryView = pickerViewToolBar
    }
    
    //toolbar按钮事件
    @objc func clickOKButton() {
        tomatoTime = self.pickerView.selectedRow(inComponent: 0) * 5 + 5
        timeTextField.text = String(tomatoTime) + "分钟"
        timeTextField.resignFirstResponder()
    }
    
    @objc func clickCancelButton() {
        timeTextField.text = String(tomatoTime) + "分钟"
        timeTextField.resignFirstResponder()
    }
    
    //种植暂停按钮
    @IBAction func clickPauseButton(_ sender: UISwitch) {
        isPaused = pauseButton.isOn
    }
    
    //免打扰按钮
    @IBAction func clickNotdisturbButton(_ sender: UISwitch) {
        isNotDisturb = notdisturbButton.isOn
    }
    
    //播放白噪声开关
    @IBAction func clickPlaySound(_ sender: UISwitch) {
        if(playSwitch.isOn){
            isPlaySound = 1
            if(isDiscountBegin){
                musicModel.playSound(which: currentWeather)
            }
        }else{
            isPlaySound = 0
            if(isDiscountBegin){
                musicModel.playStop()
            }
        }
    }
}

extension SettingTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
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
