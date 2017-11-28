//
//  settingTableViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/11/25.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
class SettingTableViewController:UITableViewController{
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func startSettingTime(_ sender: UITextField) {
        print("123")
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(2, inComponent : 0, animated:true)
        pickerView.alpha = 1
        timeTextField.resignFirstResponder() //hide keyboard
        //timeTextField.inputView = pickerView
        let toolView : UIToolbar = UIToolbar()
        timeTextField.inputAccessoryView = toolView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
