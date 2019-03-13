//
//  SegmentStyle.swift
//  MagiPageView
//
//  Created by 安然 on 2017/11/10.
//  Copyright © 2017年 MacBook. All rights reserved.
//

import UIKit


/// 通知使用示例
/**
 override func viewDidLoad() {
 super.viewDidLoad()
 NotificationCenter.default.addObserver(self,
 selector: #selector(self.didSelectIndex(_:)),
 name: NSNotification.Name(ScrollPageViewDidShowThePageNotification),
 object: nil)
 }
 
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 
 }
 
 func didSelectIndex(_ noti: NSNotification) {
 if let userInfo = noti.userInfo!["currentIndex"] {
 print(userInfo)
 }
 }
 
 特别注意的是如果你的控制器是使用的storyBoard初始化, 务必重写这个初始化方法中注册通知监听者, 如果在viewDidLoad中注册,在第一次的时候将不会接受到通知
 required init?(coder aDecoder: NSCoder) {
 super.init(coder: aDecoder)
 NotificationCenter.default.addObserver(self,
 selector: #selector(self.didSelectIndex(_:)),
 name: NSNotification.Name(ScrollPageViewDidShowThePageNotification),
 object: nil)
 
 }
 func didSelectIndex(_ noti: NSNotification) {
 //注意键名是currentIndex
 if let userInfo = noti.userInfo!["currentIndex"] {
 print(userInfo)
 }
 */

public let ScrollPageViewDidShowThePageNotification = "ScrollPageViewDidShowThePageNotification"

public struct SegmentStyle {



    /// 添加背景属性
    public var backgroundColor = UIColor.clear
    public var backgroundBorderColor = UIColor.clear
    public var backgroundBorderWidth: CGFloat = 0.0
    /// 固定主题宽度(自适应就失效了)
    public var titleWidth: CGFloat = 0.0
    /// 旁边按钮的透明度
    public var isExtraBtnAlph = false
    /// 边距 遮盖和文字的间隙
    public var titleEdgeWidth: CGFloat = 5.0
    /// 是否有动画
    public var isAnimation = true
    /// 是否显示遮盖
    public var isShowCover = false
    /// 是否显示下划线
    public var isShowLine = false
    /// 是否缩放文字
    public var isScaleTitle = false
    /// 是否可以滚动标题
    public var isScrollTitle = true
    /// 是否颜色渐变
    public var isGradualChangeTitleColor = false
    /// 是否显示附加的按钮
    public var isShowExtraButton = false
    /// 点击title切换内容的时候是否有动画
    public var isChangeContentAnimated = true
    // 切换内容的时候title是否有动画
    public var isChangeTitleAnimated = true
    
    public var isShowBottomLine = false
    
    public var extraBtnBackgroundImageName: String?
    
    public var edgeWidth: CGFloat = 0
    /// 下面的滚动条的高度 默认2
    public var scrollLineHeight: CGFloat = 2

    public var scrollLineWidth: CGFloat = 0
    /// 下面的滚动条的颜色
    public var scrollLineColor = UIColor.brown
    
    public var bottomLineColor = UIColor.black
    /// 遮盖的背景颜色
    public var coverBackgroundColor = UIColor.lightGray
    /// 遮盖圆角
    public var coverCornerRadius: CGFloat = 14.0
    /// cover的高度 默认28
    public var coverHeight: CGFloat = 28.0
    /// 文字间的间隔 默认15
    public var titleMargin: CGFloat = 15
    /// 文字 字体 默认14.0
    public var titleFont = UIFont.systemFont(ofSize: 15.0)
    /// 放大倍数 默认1.3
    public var titleBigScale: CGFloat = 1.3
    /// 默认倍数 不可修改
    let titleOriginalScale: CGFloat = 1.0
    /// 文字正常状态颜色 请使用RGB空间的颜色值!! 如果提供的不是RGB空间的颜色值就可能crash
    public var normalTitleColor = UIColor(red: 51.0/255.0, green: 53.0/255.0, blue: 75/255.0, alpha: 1.0)
    /// 文字选中状态颜色 请使用RGB空间的颜色值!! 如果提供的不是RGB空间的颜色值就可能crash
    public var selectedTitleColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 121/255.0, alpha: 1.0)
    
    public init() {
        
    }
    
}
