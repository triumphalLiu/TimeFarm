//
//  GlobalData.swift
//  TimeFarm
//
//  Created by apple on 2017/11/29.
//  Copyright © 2017年 liu. All rights reserved.
//

import Foundation
import UIKit

var tomatoTime : Int = 0 //初始番茄时间25min save
var isNotDisturb : Bool = false //初始非免打扰 save
var currentCity : String = "init" //初始城市 save
var currentSeedNum : Int = 0 //当前选择的作物 save
var currentTimes : Int = 0 //次数
//当前成就
var currentTomato : Int = 0 //save
var currentGrape : Int = 0 //save
var currentWaterMelon : Int = 0 //save

//每次打开程序都重置的数据
let seedList : [String] = ["tomato.png", "grape.png", "watermelon.png"]
var isPaused : Bool = false //初始非特殊情况暂停
var isDiscountBegin : Bool = false //是否已经开始倒计时
var discountTime : Int = 0 //倒计时时间
var lockTime : Date! //锁屏的时间
var resumeTime : Date! //恢复的时间
var thisTime : Int = 0 //本次专注时间
var startTime : Date! //开始的时间

let dataModel : DataModel = DataModel()
let logModel : LogModel = LogModel()
