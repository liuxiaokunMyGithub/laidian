//
//  SSTextMarquee.swift
//  DemoMarQuee
//
//  Created by SHEN on 2018/10/17.
//  Copyright © 2018 shj. All rights reserved.
//

import UIKit

enum SSTextMarqueeDirection: Int {
    case verticalDown
    case verticalUp
    case horizontalLeft
    case horizontalRight
}

protocol SSTextMarqueeDelegate: class {
    func textMarqueeDidTapTitle(_ marquee: SSTextMarquee, _ title: String, _ index: Int)
}

extension SSTextMarqueeDelegate {
    func textMarqueeDidTapTitle(_ marquee: SSTextMarquee, _ title: String, _ index: Int) {}
}

/**
 文本跑马灯
 */
class SSTextMarquee: UIView {
    private class TimerWrapper {
        weak var interactor: SSTextMarquee?
        init(_ interactor: SSTextMarquee) {
            self.interactor = interactor
        }
        
        @objc func timerUpdating() {
            interactor?.timerUpdating()
        }
    }
    
    lazy var curLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var nextLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    /// 需要显示的文本列表
    var titles: [String] = [] {
        didSet {
            updateView()
        }
    }
    
    /// 文本字体
    var font: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            curLabel.font = font
            nextLabel.font = font
        }
    }
    
    /// 文本颜色
    var textColor: UIColor = .black {
        didSet {
            curLabel.textColor = textColor
            nextLabel.textColor = textColor
        }
    }
    
    /// 文本行数
    var numberOfLines: Int = 0 {
        didSet {
            curLabel.numberOfLines = numberOfLines
            nextLabel.numberOfLines = numberOfLines
        }
    }
    
    /// 代理
    weak var delegate: SSTextMarqueeDelegate?
    
    // 文本的边距
    var padding: UIEdgeInsets = UIEdgeInsets.zero
    
    /// 滚动方向
    var direction: SSTextMarqueeDirection = .horizontalRight
    
    /// 动画间隔
    var interval: TimeInterval = 2.0
    
    /// 动画间隔
    var animateDuration: TimeInterval = 0.5
    
    /// 定时器
    var timer: Timer?
    
    /// 当前的显示文本在 titles 中的 index
    var curIndex: Int = 0
    
    /// 是否进行定时器动画
    private var shouldAnimate = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopTimer()
        print("SSTextMarquee deinit")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animateLables(false)
    }
    
    private func initView() {
        addSubview(curLabel)
        addSubview(nextLabel)
        layer.masksToBounds = true
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureTap(_:)))
        addGestureRecognizer(tapGesture)
        
    }
    
    /// 根据 titles 来更新视图
    private func updateView() {
        if titles.count == 0 {
            shouldAnimate = false
        } else if titles.count == 1 {
            shouldAnimate = false
            curLabel.text = titles[0]
        }  else {
            shouldAnimate = true
            curLabel.text = titles[0]
            nextLabel.text = titles[1]
        }
    }
    
    @objc private func gestureTap(_ gesture: UITapGestureRecognizer) {
        if let delegate = delegate {
            delegate.textMarqueeDidTapTitle(self, titles[curIndex], curIndex)
        }
    }
    
    /// 文本动画
    ///
    /// - Parameter shouldSwitch: 是否需要进行切换文本动画
    private func animateLables(_ shouldSwitch: Bool = true) {
        let (prevLabelFrame, curLabelFrame, nextLabelFrame) = getAnimateFrame()
        
        curLabel.frame = curLabelFrame
        nextLabel.frame = nextLabelFrame
        
        if (!shouldSwitch) {
            return
        }
        UIView.animate(withDuration: animateDuration, animations: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.curLabel.frame = prevLabelFrame
            strongSelf.nextLabel.frame = curLabelFrame
            
        }) { [weak self] (finished) in
            guard let strongSelf = self else {
                return
            }
            // 重置位置
            strongSelf.curLabel.frame = curLabelFrame
            strongSelf.nextLabel.frame = nextLabelFrame
 
            // 更新
            strongSelf.switchNext()
        }
    }
    
    /// 根据运动方法获取：前一个、当前、下一个的frame
    ///
    /// - Returns: 前一个、当前、下一个
    private func getAnimateFrame() -> (CGRect, CGRect, CGRect) {
        let w = bounds.width
        let h = bounds.height
        var prevFrame = CGRect.zero
        var curFrame = CGRect.zero
        var nextFrame = CGRect.zero
        switch direction {
        case .verticalUp:
            prevFrame = CGRect(x: 0, y: -h, width: w, height: h)
            curFrame = CGRect(x: 0, y: 0, width: w, height: h)
            nextFrame = CGRect(x: 0, y: h, width: w, height: h)
        case .verticalDown:
            prevFrame = CGRect(x: 0, y: h, width: w, height: h)
            curFrame = CGRect(x: 0, y: 0, width: w, height: h)
            nextFrame = CGRect(x: 0, y: -h, width: w, height: h)
        case .horizontalLeft:
            prevFrame = CGRect(x: -w, y: 0, width: w, height: h)
            curFrame = CGRect(x: 0, y: 0, width: w, height: h)
            nextFrame = CGRect(x: w, y: 0, width: w, height: h)
        case .horizontalRight:
            prevFrame = CGRect(x: w, y: 0, width: w, height: h)
            curFrame = CGRect(x: 0, y: 0, width: w, height: h)
            nextFrame = CGRect(x: -w, y: 0, width: w, height: h)
        }
        prevFrame = prevFrame.inset(by: padding)
        curFrame = curFrame.inset(by: padding)
        nextFrame = nextFrame.inset(by: padding)
        return (prevFrame, curFrame, nextFrame)
    }
    
    /// 切换下一个显示位置
    private func switchNext() {
        let num = titles.count
        // 更新文本
        curLabel.text = titles[(curIndex + 1) % num]
        nextLabel.text = titles[(curIndex + 2) % num]
        
        // 更新 index
        var idx = curIndex + 1
        if idx > num - 1 {
            idx = 0
        }
        curIndex = idx
    }
    
    /// 开始定时器
    private func startTimer() {
        // 首先t停止定时器
        stopTimer()
        
        // 不需要定时动画就返回
        if !shouldAnimate {
            return
        }
        
        // 开启定时动画
        timer = Timer.scheduledTimer(timeInterval: (interval + animateDuration), target: TimerWrapper(self), selector: #selector(timerUpdating), userInfo: nil, repeats: true)
        let delay = DispatchTimeInterval.microseconds(Int(interval * 1000 * 1000))
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let timer = strongSelf.timer {
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }
    
    /// 停止定时器
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 定时器调用方法
    @objc func timerUpdating() {
        animateLables()
    }
    
    /// 开始动画
    func startAnimation() {
        startTimer()
    }
}
