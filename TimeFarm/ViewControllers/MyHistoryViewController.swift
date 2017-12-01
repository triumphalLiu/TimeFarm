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
        print(historyArray)
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
        return currentTimes
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryRecordCell
        print(currentTimes)
        print(indexPath.section)
        cell.dateLabel.text = historyArray[String(currentTimes - indexPath.section)]?[0]
        cell.detailLabel.text = historyArray[String(currentTimes - indexPath.section)]?[3]
        let imageNo : Int! = Int(historyArray[String(currentTimes - indexPath.section)]?[2] as String!)
        cell.seedImage.image = UIImage(named:seedList[imageNo])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keys = Array(historyArray.keys)
        let alertController = UIAlertController(title: "选择操作", message: "请选择一项要进行的操作", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let archiveAction = UIAlertAction(title: "查看详情", style: .default, handler:{
            (alerts: UIAlertAction!) ->Void in
            var msg : String = "\n"
            msg.append("种植时间：\n\(self.historyArray[keys[indexPath.section]]![0] as String)\n")
            msg.append("收成情况：\n\(self.historyArray[keys[indexPath.section]]![3] as String)\n")
            msg.append("专注时长：\n\(self.historyArray[keys[indexPath.section]]![4] as String + "分钟")\n")
            let alertController = UIAlertController(title: "本次专注的详细情况", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler:nil)
            alertController.addAction(okAction)
            self.present(alertController, animated : true,completion : nil)
        })
        let deleteAction = UIAlertAction(title: "删除", style: .destructive, handler:{
            (alerts: UIAlertAction!) ->Void in
            print(indexPath.section)
            self.logModel.removeLog(key: String(currentTimes - indexPath.section))
            self.historyArray = self.logModel.readLog()
            self.tableView.reloadData()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(archiveAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}
