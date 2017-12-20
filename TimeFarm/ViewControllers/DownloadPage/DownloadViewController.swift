//
//  DownloadViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/12/20.
//  Copyright © 2017年 liu. All rights reserved.
//

import Foundation
import UIKit

class DownloadViewController : UITableViewController{
    
    var timer : Timer! = Timer()
    //倒计时定时器方法
    @objc func tickDown1s() {
        if(downloadModel.currentFileID == -1){
            return
        }
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0,
                                                           section: downloadModel.currentFileID)) as! DownloadCell
        cell.progressBar.progress = downloadModel.progress
        if(cell.progressBar.progress >= 1.0){
            downloadModel.currentFileID = -1
            cell.progressBar.isHidden = true
            cell.downloadButton.isEnabled = false
            cell.downloadButton.titleLabel?.text = "完成"
            cell.progressBar.progress = 0
            cell.downloading = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1),
                                     target: self, selector: #selector(tickDown1s), userInfo: nil, repeats: true)
        self.tableView.rowHeight = 75
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadCell", for: indexPath) as! DownloadCell
        switch indexPath.section {
        case 0:
            cell.nameLabel.text = "晴天-鸟鸣"
            cell.sizeLabel.text = "5.5 MB"
            break
        case 1:
            cell.nameLabel.text = "刮风-大风"
            cell.sizeLabel.text = "4.8 MB"
            break
        case 2:
            cell.nameLabel.text = "雨天-瀑布"
            cell.sizeLabel.text = "5.9 MB"
            break
        default:
            break
        }
        cell.downloadButton.isEnabled = !isFileExist(musicList[indexPath.section])
        cell.progressBar.isHidden = true
        print(cell.downloadButton.isEnabled)
        if(cell.downloadButton.isEnabled){
            cell.downloadButton.titleLabel!.text = "下载"
        }
        else{
            cell.downloadButton.titleLabel!.text = "完成"
        }
        return cell
    }
    
    func isFileExist(_ filename : String) -> Bool {
        let fileManager = FileManager()
        let docs : String = NSHomeDirectory() + "/Documents/\(filename)"
        let dbexits : Bool = fileManager.fileExists(atPath: docs)
        return dbexits
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! DownloadCell
        if(cell.downloading == false) {
            if(cell.downloadButton.isEnabled){
                if(downloadModel.currentFileID != -1){
                    let alertController=UIAlertController(title: "创建任务失败",
                                                          message: "当前存在下载任务，请等待结束后再下载", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction=UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler:nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated : true,completion : nil)
                }
                else{
                    cell.downloadButton.titleLabel!.text = "取消"
                    downloadModel.sessionSeniorDownload(musicList[indexPath.section])
                    cell.progressBar.isHidden = false
                    cell.progressBar.progress = downloadModel.progress
                    cell.downloading = true
                }
            }
            else{
                let alertController = UIAlertController(title: "删除文件",
                                                        message: "您确定要删除这个文件吗？", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
                let settingsAction = UIAlertAction(title:"删除", style: .destructive, handler: {
                    (action) -> Void in
                    let fileManager = FileManager()
                    let filename = musicList[indexPath.section]
                    let path = NSHomeDirectory() + "/Documents/\(filename)"
                    print(path)
                    do{
                        try fileManager.removeItem(atPath: path)
                    }
                    catch{
                        print("error in delete file of download")
                    }
                    cell.downloadButton.isEnabled = true
                    cell.downloadButton.titleLabel?.text = "下载"
                    cell.progressBar.progress = 0.0
                })
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated : true,completion : nil)
            }
        }
        else if(cell.downloading == true){
            cell.downloadButton.titleLabel!.text = "下载"
            downloadModel.pauseDownload()
            cell.progressBar.isHidden = true
            cell.progressBar.progress = downloadModel.progress
            cell.downloading = false
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
