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
    var pickerView : UIPickerView!
    
    @IBAction func startSettingTime(_ sender: UITextField) {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(4, inComponent : 0, animated: true)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func clickOKButton() {
        timeTextField.text = String(self.pickerView.selectedRow(inComponent: 0) * 5 + 5) + "分钟"
        //修改内存的值
        timeTextField.resignFirstResponder()
    }
    
    @objc func clickCancelButton() {
        timeTextField.text = "xx" + "分钟"
        timeTextField.resignFirstResponder()
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
