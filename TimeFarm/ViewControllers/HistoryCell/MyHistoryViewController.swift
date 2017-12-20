//
//  MyHistoryViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
import Photos
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
        let result = getScreenShot()
        print(result)
        let height : CGFloat = 150
        let pop : CGFloat = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        let width : CGFloat = pop * height
        let img = UIImageView(frame: CGRect(x: 20, y: UIScreen.main.bounds.height - height - 100, width: width, height: height))
        img.image = result
        self.view.addSubview(img)
        
        let alertController=UIAlertController(title: "已截图", message: "截图已经保存到相册啦～", preferredStyle: UIAlertControllerStyle.alert)
        let okAction=UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler:nil)
        alertController.addAction(okAction)
        self.present(alertController, animated : true,completion : nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return historyArray.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryRecordCell
        print(currentTimes)
        print(indexPath.section)
        let succ = historyArray[String(currentTimes - indexPath.section)]?[1]
        cell.dateLabel.text = historyArray[String(currentTimes - indexPath.section)]?[0]
        cell.detailLabel.text = historyArray[String(currentTimes - indexPath.section)]?[3]
        let imageNo : Int! = Int(historyArray[String(currentTimes - indexPath.section)]?[2] as String!)
        if succ == "1"{
            cell.seedImage.image = UIImage(named:seedList[imageNo])
        }else{
            cell.seedImage.image = UIImage(named:seedDeadList[imageNo])
        }
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
    
    func getScreenShot() -> UIImage {
        let window = UIApplication.shared.keyWindow!
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image : UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        return image
    }
}
