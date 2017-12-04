//
//  MusicModel.swift
//  TimeFarm
//
//  Created by apple on 2017/12/4.
//  Copyright © 2017年 liu. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class MusicModel{
    //播放器相关
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    
    //播放
    func playSound(which: Int) {
        playerItem = AVPlayerItem(url: URL(fileURLWithPath: musicPath(which: which)))
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
    
    //停止
    func playStop() {
        player?.pause()
    }
    
    //路径
    func musicPath(which: Int) -> String{
        return Bundle.main.path(forResource: musicList[which], ofType: "")!
    }
}
