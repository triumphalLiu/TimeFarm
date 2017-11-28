//
//  ChooseCityTableViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/11/25.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
class ChooseCityViewController:UIViewController{
    
    
    @IBOutlet weak var tableView: UITableView!
    //加载城市数据
    lazy var cityDic: [String: [String]] = { () -> [String : [String]] in
        let path = Bundle.main.path(forResource: "cities", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path ?? "") as? [String: [String]]
        return dic ?? [:]
    }()
    
    lazy var cityArray: [String] = { () -> [String] in
        var arr = [String]()
        for (keys, values) in self.cityDic{
            arr.append(contentsOf: values)
        }
        return arr
    }()
    
    //加载标题
    lazy var titleArray: [String] = { () -> [String] in
        var array = [String]()
        for str in self.cityDic.keys {
            array.append(str)
        }
        array.sort()
        array.insert("定位", at: 0)
        return array
    }()
    
    //搜索结果
    var resultArray : [String] = [String](){
        didSet {self.tableView.reloadData()}
    }
    
    //搜索控制器
    var ChooseCitySearchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.sectionIndexBackgroundColor = UIColor.clear
        
        self.ChooseCitySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder =  "输入城市名或拼音"
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
}

//search扩展
extension ChooseCityViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        self.resultArray = self.cityArray.filter { (city) -> Bool in
            return city.contains(self.ChooseCitySearchController.searchBar.text!)
        }
    }
}

//table view扩展
extension ChooseCityViewController: UITableViewDelegate ,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(ChooseCitySearchController.isActive) {
            return 1
        }
        else {
            return titleArray.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(ChooseCitySearchController.isActive) {
            return resultArray.count
        }
        else {
            if section > 0 {
                let key = titleArray[section]
                return cityDic[key]!.count
            }
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCityTableViewCell", for: indexPath) as! ChooseCityTableViewCell
        if(ChooseCitySearchController.isActive){
            cell.cityNameLabel.text = self.resultArray[indexPath.row]
            return cell
        }
        else {
            let key = titleArray[indexPath.section]
            if indexPath.section == 0 {
                cell.cityNameLabel!.text = "当前定位"
            }
            else {
                cell.cityNameLabel.text = cityDic[key]?[indexPath.row]
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as! ChooseCityTableViewCell
        print("点击了 \(cell.cityNameLabel.text)")
        //把值返回给上一层
    }

    //右侧导航栏
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if(ChooseCitySearchController.isActive) {
            return nil
        }
        else {
            return titleArray
        }
    }

    //secton头
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        let title = UILabel(frame: CGRect(x: 12, y: 0, width: UIScreen.main.bounds.width - 12, height: 20))
        var titleArr = titleArray
        if(ChooseCitySearchController.isActive){
            title.text = "查找结果"
        }
        else{
            titleArr[0] = "定位城市"
            title.text = titleArr[section]
        }
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(title)
        view.backgroundColor = UIColor.gray
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

