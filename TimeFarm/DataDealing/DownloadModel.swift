//
//  DownloadModel.swift
//  TimeFarm
//
//  Created by apple on 2017/12/20.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit

class DownloadModel : UIViewController, URLSessionDownloadDelegate{
    
    var progress : Float = 0.0
    let url_sunny = "http://audio.xmcdn.com/group30/M04/33/50/wKgJXlnMpZzih-L-AfOmBVbFP0E823.m4a"
    let url_windy = "http://audio.xmcdn.com/group30/M08/57/E9/wKgJWlnMoxTzrwVlAKGb-VRRqiY976.m4a"
    let url_rainy = "http://audio.xmcdn.com/group30/M02/33/0E/wKgJXlnMo2zQg1bJAYhPeQWo4KY492.m4a"
    var currentFile : String = ""
    var downloadTask : URLSessionDownloadTask!
    var currentFileID : Int = -1
    
    private lazy var session : URLSession = {
        let config = URLSessionConfiguration.default
        let currentSession = URLSession(configuration: config, delegate: self,
                                        delegateQueue: nil)
        return currentSession
    }()
    
    func sessionSeniorDownload(_ path:String){
        print(progress)
        switch path {
        case musicList[0]:
            currentFile = url_sunny
            currentFileID = 0
            break
        case musicList[1]:
            currentFile = url_windy
            currentFileID = 1
            break
        case musicList[2]:
            currentFile = url_rainy
            currentFileID = 2
            break
        default:
            return
        }
        let url = URL(string: currentFile)
        let request = URLRequest(url: url!)
        print(request)
        downloadTask = session.downloadTask(with: request)
        print(downloadTask.description)
        downloadTask.resume()
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        print("下载结束")
        print("location:\(location)")
        let locationPath = location.path
        var fname = ""
        switch currentFile {
        case url_sunny:
            fname = "sunny.m4a"
            break
        case url_windy:
            fname = "windy.m4a"
            break
        case url_rainy:
            fname = "rainy.m4a"
            break
        default:
            break
        }
        let docs : String = NSHomeDirectory() + "/Documents/\(fname)"
        let fileManager = FileManager.default
        do {
            try fileManager.moveItem(atPath: locationPath, toPath: docs)
            print("new location:\(docs)")
        } catch  {
            print("error")
        }
    }
    
    //下载代理方法，监听下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        let written:CGFloat = CGFloat(totalBytesWritten)
        let total:CGFloat = CGFloat(totalBytesExpectedToWrite)
        let pro:CGFloat = written/total
        print("下载进度：\(pro)")
        progress = Float(pro)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
    }
    
    func pauseDownload() {
        downloadTask.suspend()
    }
}
