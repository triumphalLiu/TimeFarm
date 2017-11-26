//
//  ChooseCityTableViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/11/25.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
class ChooseCityTableViewController:UITableViewController{
    
    //加载城市数据
    lazy var cityDic: [String: [String]] = { () -> [String : [String]] in
        let path = Bundle.main.path(forResource: "cities", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path ?? "") as? [String: [String]]
        return dic ?? [:]
    }()
    
    //加载标题
    lazy var titleArray: [String] = { () -> [String] in
        var array = [String]()
        for str in self.cityDic.keys {
            array.append(str)
        }
        array.sort()
        array.insert("定位城市", at: 0)
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cityDic)
        print(titleArray)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 0 {
            let key = titleArray[section]
            return cityDic[key]!.count - 3
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCityTableViewCell", for: indexPath) as! ChooseCityTableViewCell
        let key = titleArray[indexPath.section]
        if indexPath.section == 0 {
            cell.cityNameLabel!.text = "当前定位"
        }
        else {
            cell.cityNameLabel.text = cityDic[key]?[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as! ChooseCityTableViewCell
        print("点击了 \(cell.cityNameLabel.text)")
        //把值返回给上一层
    }
}
