//
//  MyHistoryViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
class MyHistoryViewController:UITableViewController{
    
    let logModel = LogModel()
    
    lazy var historyArray = logModel.readLog()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 75
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func clickShare(_ sender: UIBarButtonItem) {
        print("going to share!")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Array(historyArray.keys).count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryRecordCell
        cell.dateLabel.text = historyArray[String(currentTimes - indexPath.section)]?[0]
        cell.detailLabel.text = historyArray[String(currentTimes - indexPath.section)]?[3]
        let imageNo : Int! = Int(historyArray[String(currentTimes - indexPath.section)]?[2] as String!)
        cell.seedImage.image = UIImage(named:seedList[imageNo])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("111")
    }

}
