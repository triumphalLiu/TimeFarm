//
//  GlobalData.swift
//  TimeFarm
//
//  Created by apple on 2017/11/29.
//  Copyright © 2017年 liu. All rights reserved.
//

import Foundation
import UIKit

var tomatoTime : Int = 25 //初始番茄时间25min save
var isPaused : Bool = false //初始非暂停
var isNotDisterb : Bool = false //初始非免打扰 save
var currentCity : String = "北京" //初始城市 save

let seedList : [String] = ["tomato.png", "grape.png", "watermelon.png"]
var currentSeedNum : Int = 0 //默认为番茄 save

var currentTomato : Int = 0 //save
var currentGrape : Int = 0 //save
var currentWaterMelon : Int = 0 //当前成就 save

var isDiscountBegin : Bool = false //是否已经开始倒计时
var discountTime : Int = 0 //倒计时时间
