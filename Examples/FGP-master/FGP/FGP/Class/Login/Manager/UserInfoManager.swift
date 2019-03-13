//
//  UserInfoManager.swift
//  FGP
//
//  Created by briceZhao on 2018/9/3.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit

class UserInfoManager: NSObject {
    
    static let instance: UserInfoManager = UserInfoManager()
    
    class func shareWindow() -> UserInfoManager {
        
        
        return instance
    }
    
    var myModel: UserInfoModel?
    
    func removeUserInfo() {
        UserDefaults.standard.removeObject(forKey: kUserPhoneNum)
        UserDefaults.standard.removeObject(forKey: kUserId)
    }
}
