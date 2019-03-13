//
//  SegmentView.swift
//  MagiPageView
//
//  Created by 安然 on 2017/11/10.
//  Copyright © 2017年 MacBook. All rights reserved.
//

import UIKit

public class SegmentView: UIView {
    
    // MARK : - 控件
    
    /// title设置(style setting)
    public var segmentStyle: SegmentStyle
    /// 点击响应的closure(click title)
    public var titleBtnOnClick:((_ label: UILabel, _ index: Int) -> Void)?
    /// 附加按钮点击响应(click extraBtn)
    public var extraBtnOnClick: ((_ extraBtn: UIButton) -> Void)?
    /// self.bounds.size.width
    fileprivate var currentWidth: CGFloat = 0
    /// 遮盖和文字的间隙
    fileprivate var xGap: CGFloat {
        set{
        }
        get {
            return segmentStyle.titleEdgeWidth
        }
    }
    /// 遮盖宽度比文字宽度多的部分
    fileprivate var wGap: CGFloat {
        return 2 * xGap
    }
    /// 缓存标题labels( save labels )
    fileprivate var labelsArray: [UILabel] = []
    /// 记录当前选中的下标
    fileprivate var currentIndex = 0
    /// 记录上一个下标
    fileprivate var oldIndex = 0
    /// 用来缓存所有标题的宽度, 达到根据文字的字数和font自适应控件的宽度(save titles; width)
    fileprivate var titlesWidthArray: [CGFloat] = []

    fileprivate var backgroundViews: [UIView] = []
    /// 用来缓存所有的背景宽度, 达到根据文字的字数和font自适应控件的宽度(save titles; width)
    fileprivate var backgroundViewWidthArray: [CGFloat] = []

    /// 所有的标题
    fileprivate var titles:[String]
    /// 管理标题的滚动
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.bounces = true
        scrollV.isPagingEnabled = false
        scrollV.scrollsToTop = false
        return scrollV
    }()
    /// 滚动条
    fileprivate lazy var scrollLine: UIView? = {[unowned self] in
        let line = UIView()
        return self.segmentStyle.isShowLine ? line : nil
        }()
    /// 遮盖
    fileprivate lazy var coverLayer: UIView? = {[unowned self] in
        let cover = UIView()
        cover.layer.cornerRadius = self.segmentStyle.coverCornerRadius
        cover.layer.masksToBounds = true
        return self.segmentStyle.isShowCover ? cover :nil
        }()
    
    /// 附加的按钮
    fileprivate lazy var extraButton: UIButton? = {[unowned self] in
        let btn = UIButton()
        btn.layer.shadowOpacity = 1
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowOffset = CGSize(width: -5, height: 0)
        if self.segmentStyle.isExtraBtnAlph {
            btn.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
        else {
            btn.backgroundColor = UIColor.white
        }

        let imageName = self.segmentStyle.extraBtnBackgroundImageName ?? "news_topic_add"
        btn.setImage(UIImage(named:imageName),
                     for: .normal)
        btn.addTarget(self,
                      action: #selector(self.extraBtnOnClick(_:)),
                      for: .touchUpInside)
        btn.backgroundColor = UIColor.white
        
        return self.segmentStyle.isShowExtraButton ? btn : nil
        }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    /// 懒加载颜色的rgb变化值, 不要每次滚动时都计算
    fileprivate lazy var rgbDelta: (deltaR: CGFloat, deltaG: CGFloat, deltaB: CGFloat) = {[unowned self] in
        let normalColorRgb = self.normalColorRgb
        let selectedTitleColorRgb = self.selectedTitleColorRgb
        let deltaR = normalColorRgb.r - selectedTitleColorRgb.r
        let deltaG = normalColorRgb.g - selectedTitleColorRgb.g
        let deltaB = normalColorRgb.b - selectedTitleColorRgb.b
        return (deltaR: deltaR, deltaG: deltaG, deltaB: deltaB)
        }()
    
    /// 懒加载颜色的rgb变化值, 不要每次滚动时都计算
    fileprivate lazy var normalColorRgb: (r: CGFloat, g: CGFloat, b: CGFloat) = {
        
        if let normalRgb = self.getColorRGB(color: self.segmentStyle.normalTitleColor) {
            return normalRgb
        }
        else {
            fatalError("设置普通状态的文字颜色时 请使用RGB空间的颜色值")
        }
    }()
    
    fileprivate lazy var selectedTitleColorRgb: (r: CGFloat, g: CGFloat, b: CGFloat) =  {
        if let selectedRgb = self.getColorRGB(color: self.segmentStyle.selectedTitleColor) {
            return selectedRgb
        }
        else {
            fatalError("设置选中状态的文字颜色时 请使用RGB空间的颜色值")
        }
        
    }()
    
    // FIXME: 如果提供的不是RGB空间的颜色值就可能crash
    fileprivate func getColorRGB(color: UIColor) -> (r: CGFloat, g: CGFloat, b: CGFloat)? {
        let numOfComponents = color.cgColor.numberOfComponents
        if numOfComponents == 4 {
            let componemts = color.cgColor.components
            return (r: componemts![0], g: componemts![1], b: componemts![2])
        }
        return nil
    }
    /// 背景图片
    public var backgroundImage: UIImage? = nil {
        didSet {
            // 在设置了背景图片的时候才添加imageView
            if let image = backgroundImage {
                backgroundImageView.image = image
                insertSubview(backgroundImageView, at: 0)
            }
        }
    }
    
    fileprivate lazy var backgroundImageView: UIImageView = {[unowned self] in
        let imageView = UIImageView(frame: self.bounds)
        return imageView
        }()
    
    // MARK: - life cycle
    public init(frame: CGRect, segmentStyle: SegmentStyle, titles: [String]) {
        self.segmentStyle = segmentStyle
        self.titles = titles
        super.init(frame: frame)
        if !self.segmentStyle.isScrollTitle {
            // 不能滚动的时候就不要把缩放和遮盖或者滚动条同时使用, 否则显示效果不好
            self.segmentStyle.isScaleTitle = !(self.segmentStyle.isShowCover || self.segmentStyle.isShowLine)
        }
        // 根据titles添加相应的控件
        setupTitles()
        // 设置frame
        setupUI()
        addSubview(scrollView)
        // 添加附加按钮
        if let extraBtn = extraButton {
            addSubview(extraBtn)
        }
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func titleLabelOnClick(_ tapGes: UITapGestureRecognizer) {
        
        guard let currentLabel = tapGes.view as? MagiTitleLabel else { return }
        currentIndex = currentLabel.tag
        adjustUIWhenBtnOnClickWithAnimate(animated: segmentStyle.isAnimation)
    }
    
    @objc func extraBtnOnClick(_ btn: UIButton) {
        extraBtnOnClick?(btn)
    }
    
    deinit {
        print("\(self.debugDescription) --- 销毁")
    }
}

extension SegmentView {
    ///  对外界暴露设置选中的下标的方法 可以改变设置下标滚动后是否有动画切换效果
    public func selectedIndex(selectedIndex: Int, animated: Bool) {
        assert(!(selectedIndex < 0 || selectedIndex >= titles.count),
               "设置的下标不合法!!")
        
        if selectedIndex < 0 || selectedIndex >= titles.count {
            return
        }
        // 自动调整到相应的位置
        currentIndex = selectedIndex
        adjustUIWhenBtnOnClickWithAnimate(animated: animated)

    }

    ///  对外界暴露设置选中的下标的方法去除选中效果
    public func selectedTitle(selectedIndex: Int, animated: Bool) {
        assert(!(selectedIndex < 0 || selectedIndex >= titles.count),
               "设置的下标不合法!!")

        if selectedIndex < 0 || selectedIndex >= titles.count {
            return
        }
        // 自动调整到相应的位置
        currentIndex = selectedIndex

        adjustUIWhenBtnOnClickWithAnimate(animated: animated, isSelected: false)
    }
    
    // 刷新标题的显示
    public func reloadTitlesWithNewTitles(_ titles: [String]) {
        // 移除所有的scrollView子视图
        scrollView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        // 移除所有的label相关类
        titlesWidthArray.removeAll()
        labelsArray.removeAll()
        backgroundViews.removeAll()
        backgroundViewWidthArray.removeAll()
        oldIndex = 0
        // 重新设置UI
        self.titles = titles
        setupTitles()
        setupUI()
        selectedIndex(selectedIndex: 0, animated: true)
    }
    
}



// MARK: - 设置滚动条内部title,line,cover
extension SegmentView {
    
    fileprivate func setupTitles() {

        for (index, title) in titles.enumerated() {
            let view = UIView()
            view.tag = index
            view.backgroundColor = segmentStyle.backgroundColor
            view.layer.cornerRadius = segmentStyle.coverHeight / 2
            view.layer.borderWidth = segmentStyle.backgroundBorderWidth
            view.layer.borderColor = segmentStyle.backgroundBorderColor.cgColor
            view.clipsToBounds = true
            // 计算文字尺寸
            let size = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT),
                                                                     height: 0.0),
                                                        options: .usesLineFragmentOrigin,
                                                        attributes: [NSAttributedString.Key.font: segmentStyle.titleFont],
                                                        context: nil)
            if segmentStyle.titleWidth == 0.0 {
                // 缓存文字宽度
                backgroundViewWidthArray.append(size.width + CGFloat(wGap))
            }

            else {
                // 缓存文字宽度
                backgroundViewWidthArray.append(segmentStyle.titleWidth + CGFloat(wGap))
            }

            // 缓存label
            backgroundViews.append(view)
            // 添加label
            scrollView.addSubview(view)
        }
        
        for (index, title) in titles.enumerated() {
            let label = MagiTitleLabel(frame: CGRect.zero)
            label.tag = index
            label.text = title
            label.textColor = segmentStyle.normalTitleColor
            label.font = segmentStyle.titleFont
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            
            // 添加点击手势
            let tapGes = UITapGestureRecognizer(target: self,
                                                action: #selector(self.titleLabelOnClick(_:)))
            label.addGestureRecognizer(tapGes)
            // 计算文字尺寸
            let size = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT),
                                                                     height: 0.0),
                                                        options: .usesLineFragmentOrigin,
                                                        attributes: [NSAttributedString.Key.font: label.font],
                                                        context: nil)
            if segmentStyle.titleWidth == 0.0 {
                // 缓存文字宽度
                titlesWidthArray.append(size.width)
            }
            else {
                titlesWidthArray.append(segmentStyle.titleWidth)
            }
            // 缓存label
            labelsArray.append(label)
            // 添加label
            scrollView.addSubview(label)
        }
        
    }
    
    fileprivate func setupUI() {
        // 设置extra按钮
        setupScrollViewAndExtraBtn()
        // 先设置label的位置
        setUpLabelsPosition()
        setUpBackgroundPosition()
        // 再设置滚动条和cover的位置
        setupScrollLineAndCover()
        
        if segmentStyle.isScrollTitle {
            if let lastLabel = labelsArray.last {

                if !segmentStyle.isExtraBtnAlph {
                    scrollView.contentSize = CGSize(width: lastLabel.frame.maxX + segmentStyle.titleMargin,
                                                    height: 0)

                }

                else {
                    scrollView.contentSize = CGSize(width: lastLabel.frame.maxX + segmentStyle.titleMargin + 44,
                                                    height: 0)
                }


            }
        }
        
    }
    
    private func setupScrollViewAndExtraBtn() {
        currentWidth = bounds.size.width
        let extraBtnW: CGFloat = 44.0
        let extraBtnY: CGFloat = 5.0
        var scrollW: CGFloat
        var extraButtonX: CGFloat
        if self.segmentStyle.isExtraBtnAlph {

            scrollW = currentWidth
            extraButtonX = currentWidth - 44
        }
        else {

            scrollW = extraButton == nil ? currentWidth : currentWidth - extraBtnW
            extraButtonX = scrollW
        }

        scrollView.frame = CGRect(x: 0.0,
                                  y: 0.0,
                                  width: scrollW,
                                  height: bounds.size.height)
        extraButton?.frame = CGRect(x: extraButtonX,
                                    y: extraBtnY,
                                    width: extraBtnW,
                                    height: bounds.size.height - 2*extraBtnY)
    }
    // 先设置label的位置
    fileprivate func setUpLabelsPosition() {
        var titleX: CGFloat = 0.0
        let titleY: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleH = bounds.size.height - segmentStyle.scrollLineHeight
        
        if !segmentStyle.isScrollTitle {
            // 标题不能滚动, 平分宽度
            titleW = (currentWidth - 2 * segmentStyle.edgeWidth) / CGFloat(titles.count)
            
            for (index, label) in labelsArray.enumerated() {
                
                titleX = segmentStyle.edgeWidth + CGFloat(index) * titleW
                
                label.frame = CGRect(x: titleX,
                                     y: titleY,
                                     width: titleW,
                                     height: titleH)
            }
            
        }
            
        else {
            
            for (index, label) in labelsArray.enumerated() {
                titleW = titlesWidthArray[index]
                titleX = segmentStyle.titleMargin
                if index != 0 {
                    let lastLabel = labelsArray[index - 1]
                    titleX = lastLabel.frame.maxX + segmentStyle.titleMargin
                }
                label.frame = CGRect(x: titleX,
                                     y: titleY,
                                     width: titleW,
                                     height: titleH)
                
            }
            
        }
        
        if let firstLabel = labelsArray[0] as? MagiTitleLabel {
            // 缩放, 设置初始的label的transform
            if segmentStyle.isScaleTitle {
                firstLabel.currentTransformSx = segmentStyle.titleBigScale
            }
            // 设置初始状态文字的颜色
            firstLabel.textColor = segmentStyle.selectedTitleColor
        }
        
        
    }

    // 先设置label的位置
    fileprivate func setUpBackgroundPosition() {
        var backgroundX: CGFloat = 0.0
        var backgroundY: CGFloat = 0.0
        var backgroundW: CGFloat = 0.0
        var backgroundH = bounds.size.height - segmentStyle.scrollLineHeight

        if !segmentStyle.isScrollTitle {
            backgroundH = bounds.size.height - segmentStyle.scrollLineHeight
            // 标题不能滚动, 平分宽度
            backgroundW = (currentWidth - 2 * segmentStyle.edgeWidth) / CGFloat(titles.count)
            backgroundY = 0

            for (index, back) in backgroundViews.enumerated() {

                backgroundX = segmentStyle.edgeWidth + CGFloat(index) * backgroundW

                back.frame = CGRect(x: backgroundX,
                                     y: backgroundY,
                                     width: backgroundW,
                                     height: backgroundH)
            }

        }

        else {

            for (index, back) in backgroundViews.enumerated() {
                backgroundH = segmentStyle.coverHeight
                backgroundW = backgroundViewWidthArray[index]
                backgroundX = segmentStyle.titleMargin - CGFloat(xGap)
                backgroundY = (bounds.size.height - segmentStyle.coverHeight) * 0.5
                if index != 0 {
                    let lastBack = labelsArray[index - 1]
                    backgroundX = lastBack.frame.maxX + segmentStyle.titleMargin - CGFloat(xGap)
                }
                back.frame = CGRect(x: backgroundX,
                                     y: backgroundY,
                                     width: backgroundW,
                                     height: backgroundH)

            }

        }

    }
    
    // 再设置滚动条和cover的位置
    private func setupScrollLineAndCover() {
        
        if !segmentStyle.isShowBottomLine {
            bottomLine.backgroundColor = segmentStyle.bottomLineColor
            self.addSubview(bottomLine)
            bottomLine.frame = CGRect(x: 0,
                                      y: bounds.size.height-1,
                                      width: bounds.size.width,
                                      height: 1)
        }
        
        if let line = scrollLine {
            line.backgroundColor = segmentStyle.scrollLineColor
            scrollView.addSubview(line)
        }
        
        if let cover = coverLayer {
            cover.backgroundColor = segmentStyle.coverBackgroundColor
            scrollView.insertSubview(cover, at: backgroundViews.count)
        }
        
        let coverX = labelsArray[0].frame.origin.x
        let coverW = labelsArray[0].frame.size.width
        let coverH: CGFloat = segmentStyle.coverHeight
        let coverY = (bounds.size.height - coverH) / 2
        
        if segmentStyle.isScrollTitle {
            // 这里x-xGap width+wGap 是为了让遮盖的左右边缘和文字有一定的距离
            coverLayer?.frame = CGRect(x: coverX - CGFloat(xGap),
                                       y: coverY,
                                       width: coverW + CGFloat(wGap),
                                       height: coverH)
        }
            
        else {
            coverLayer?.frame = CGRect(x: coverX,
                                       y: coverY,
                                       width: coverW,
                                       height: coverH)
        }
        
        
        if segmentStyle.isScrollTitle {
            scrollLine?.frame = CGRect(x: coverX,
                                       y: bounds.size.height - segmentStyle.scrollLineHeight,
                                       width: coverW,
                                       height: segmentStyle.scrollLineHeight)
        }
            
        else {
            scrollLine?.frame = CGRect(x: coverX + segmentStyle.scrollLineWidth,
                                       y: bounds.size.height - segmentStyle.scrollLineHeight,
                                       width: coverW - 2*segmentStyle.scrollLineWidth,
                                       height: segmentStyle.scrollLineHeight)
        }
        
        
        
    }
    
}

// MARK: - 文字缩放
extension SegmentView {
    
    // 自动或者手动点击按钮的时候调整UI
    public func adjustUIWhenBtnOnClickWithAnimate(animated: Bool, isSelected: Bool = true) {
        // 重复点击时的相应, 这里没有处理, 可以传递给外界来处理 比如刷新
        if currentIndex == oldIndex { return }
        
        let oldLabel = labelsArray[oldIndex] as! MagiTitleLabel
        let currentLabel = labelsArray[currentIndex] as! MagiTitleLabel
        
        adjustTitleOffSetToCurrentIndex(currentIndex: currentIndex)
        
        let animatedTime = animated ? 0.3 : 0.0
        UIView.animate(withDuration: animatedTime) {[unowned self] in
            // 设置文字颜色
            oldLabel.textColor = self.segmentStyle.normalTitleColor
            currentLabel.textColor = self.segmentStyle.selectedTitleColor
            
            // 缩放文字
            if self.segmentStyle.isScaleTitle {
                oldLabel.currentTransformSx = self.segmentStyle.titleOriginalScale
                currentLabel.currentTransformSx = self.segmentStyle.titleBigScale
            }
            
            if self.segmentStyle.isScrollTitle {
                // 设置滚动条的位置
                self.scrollLine?.frame.origin.x = currentLabel.frame.origin.x
                // 注意, 通过bounds 获取到的width 是没有进行transform之前的 所以使用frame
                self.scrollLine?.frame.size.width = currentLabel.frame.size.width
            }
                
            else {
                // 设置滚动条的位置
                self.scrollLine?.frame.origin.x = currentLabel.frame.origin.x + self.segmentStyle.scrollLineWidth
                // 注意, 通过bounds 获取到的width 是没有进行transform之前的 所以使用frame
                self.scrollLine?.frame.size.width = currentLabel.frame.size.width - 2*self.segmentStyle.scrollLineWidth
            }
            
            // 设置遮盖位置
            if self.segmentStyle.isScrollTitle {
                self.coverLayer?.frame.origin.x = currentLabel.frame.origin.x - CGFloat(self.xGap)
                self.coverLayer?.frame.size.width = currentLabel.frame.size.width + CGFloat(self.wGap)
            }
                
            else {
                self.coverLayer?.frame.origin.x = currentLabel.frame.origin.x
                self.coverLayer?.frame.size.width = currentLabel.frame.size.width
            }
            
        }
        
        oldIndex = currentIndex

        if isSelected {
            titleBtnOnClick?(currentLabel, currentIndex)
        }
    }
    
    // 手动滚动时需要提供动画效果
    public func adjustUIWithProgress(progress: CGFloat,  oldIndex: Int, currentIndex: Int) {
        
        // 记录当前的currentIndex以便于在点击的时候处理
        self.oldIndex = currentIndex
        
       // print("\(currentIndex)------------currentIndex")
        
        let oldLabel = labelsArray[oldIndex] as! MagiTitleLabel
        let currentLabel = labelsArray[currentIndex] as! MagiTitleLabel
        
        // 从一个label滚动到另一个label 需要改变的总的距离 和 总的宽度
        let xDistance = currentLabel.frame.origin.x - oldLabel.frame.origin.x
        let wDistance = currentLabel.frame.size.width - oldLabel.frame.size.width
        
        
        if self.segmentStyle.isScrollTitle {
            // 设置滚动条位置 = 最初的位置 + 改变的总距离 * 进度
            scrollLine?.frame.origin.x = oldLabel.frame.origin.x + xDistance * progress
            // 设置滚动条宽度 = 最初的宽度 + 改变的总宽度 * 进度
            scrollLine?.frame.size.width = oldLabel.frame.size.width + wDistance * progress
            
        }
            
        else {
            
            // 设置滚动条位置 = 最初的位置 + 改变的总距离 * 进度
            scrollLine?.frame.origin.x = oldLabel.frame.origin.x + self.segmentStyle.scrollLineWidth + xDistance * progress
            // 设置滚动条宽度 = 最初的宽度 + 改变的总宽度 * 进度
            scrollLine?.frame.size.width = oldLabel.frame.size.width - 2*self.segmentStyle.scrollLineWidth + wDistance * progress
        }
        
        // 设置 cover位置
        if segmentStyle.isScrollTitle {
            coverLayer?.frame.origin.x = oldLabel.frame.origin.x + xDistance * progress - CGFloat(xGap)
            coverLayer?.frame.size.width = oldLabel.frame.size.width + wDistance * progress + CGFloat(wGap)
        } else {
            coverLayer?.frame.origin.x = oldLabel.frame.origin.x + xDistance * progress - CGFloat(xGap)
            coverLayer?.frame.size.width = oldLabel.frame.size.width + wDistance * progress + CGFloat(wGap)
        }
        
        //        print(progress)
        // 文字颜色渐变
        if segmentStyle.isGradualChangeTitleColor {
            
            oldLabel.textColor = UIColor(red:selectedTitleColorRgb.r + rgbDelta.deltaR * progress, green: selectedTitleColorRgb.g + rgbDelta.deltaG * progress, blue: selectedTitleColorRgb.b + rgbDelta.deltaB * progress, alpha: 1.0)
            
            currentLabel.textColor = UIColor(red: normalColorRgb.r - rgbDelta.deltaR * progress, green: normalColorRgb.g - rgbDelta.deltaG * progress, blue: normalColorRgb.b - rgbDelta.deltaB * progress, alpha: 1.0)
            
        }
        
        
        // 缩放文字
        if !segmentStyle.isScaleTitle {
            return
        }
        
        // 注意左右间的比例是相关连的, 加减相同
        // 设置文字缩放
        let deltaScale = (segmentStyle.titleBigScale - segmentStyle.titleOriginalScale)
        
        oldLabel.currentTransformSx = segmentStyle.titleBigScale - deltaScale * progress
        currentLabel.currentTransformSx = segmentStyle.titleOriginalScale + deltaScale * progress
        
    }
    
    // 居中显示title
    public func adjustTitleOffSetToCurrentIndex(currentIndex: Int) {
        
        let currentLabel = labelsArray[currentIndex]
        
        labelsArray.enumerated().forEach {[unowned self] in
            if $0.offset != currentIndex {
                $0.element.textColor = self.segmentStyle.normalTitleColor
            }
        }
        // 目标是让currentLabel居中显示
        var offSetX = currentLabel.center.x - currentWidth / 2
        if offSetX < 0 {
            // 最小为0
            offSetX = 0
        }
        // considering the exist of extraButton
        let extraBtnW = extraButton?.frame.size.width ?? 0.0
        var maxOffSetX = scrollView.contentSize.width - (currentWidth - extraBtnW)
        
        // 可以滚动的区域小余屏幕宽度
        if maxOffSetX < 0 {
            maxOffSetX = 0
        }
        
        if offSetX > maxOffSetX {
            offSetX = maxOffSetX
        }
        
        scrollView.setContentOffset(CGPoint(x:offSetX, y: 0), animated: true)
        
        // 没有渐变效果的时候设置切换title时的颜色
        if !segmentStyle.isGradualChangeTitleColor {
            for (index, label) in labelsArray.enumerated() {
                
                if index == currentIndex {
                    label.textColor = segmentStyle.selectedTitleColor
                }
                    
                else {
                    label.textColor = segmentStyle.normalTitleColor
                }
                
            }
        }
        
    }
}

public class MagiTitleLabel: UILabel {
    /// 用来记录当前label的缩放比例
    public var currentTransformSx:CGFloat = 1.0 {
        didSet {
            transform = CGAffineTransform(scaleX: currentTransformSx,
                                          y: currentTransformSx)
        }
    }
}





