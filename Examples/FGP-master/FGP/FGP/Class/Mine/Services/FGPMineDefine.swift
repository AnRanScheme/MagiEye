//
//  FGPMineDefine.swift
//  FGP
//
//  Created by briceZhao on 2018/8/26.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import Foundation
import UIKit

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let kStatusBarFrame = UIApplication.shared.statusBarFrame

let iPhoneX = kStatusBarFrame.height > 20 ? true : false
let kTopLayoutHeight : CGFloat = iPhoneX ? 88.0 : 64.0
let kBottomLayoutHeight : CGFloat = iPhoneX ? 83.0 : 49.0
let kNavbarHeight : CGFloat = 44

let kAppBackColor = UIColor(hex: 0xF8F9FC)

let kUserPhoneNum = "kUserPhoneNum"
let kUserId = "kUserId"
let kUserNickName = "kUserNickName"
let kUserSessionId = "kUserSessionId"
