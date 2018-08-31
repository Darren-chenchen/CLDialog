//
//  CLDialogManager.swift
//  CLDialog
//
//  Created by darren on 2018/8/29.
//  Copyright © 2018年 陈亮陈亮. All rights reserved.
//
import UIKit

public class CLDialogManager {
    public static let share = CLDialogManager()
    var supportQuene: Bool = false
    var animationFromValue: CGFloat = 0

    public var successImage = UIImage(named: "ic_toast_success", in: BundleUtil.getCurrentBundle(), compatibleWith: nil)
    public var failImage = UIImage(named: "icon_sign", in: BundleUtil.getCurrentBundle(), compatibleWith: nil)
    /// 内容的对齐方式
    public var textAlignment = NSTextAlignment.center
    /// 设置主题色，2个按钮时只设置右边的主题色，1个按钮时显示主题色
    public var mainColor = UIColor.black
    /// 是否支持动画
    public var supportAnimate = true
    /// 自定义动画
    public var animate = CABasicAnimation()
    
    /// 针对输入框类型的弹框，限制输入框的输入条件,文本框默认没有限制，在文本框消失时，自动重置文本框的属性
    /// 最多允许输入多少个字符
    public var maxLength: Int?
    /// 只允许输入数字和小数点
    public var onlyNumberAndPoint: Bool?
    /// 设置小数点位数
    var pointLength: Int?
    /// 只允许输入数字
    public var onlyNumber: Bool?
    /// 禁止输入表情符号emoji
    public var allowEmoji: Bool?
    /// 正则表达式
    var predicateString: String?
    
    init() {
        self.setupAnimation()
    }
    
    func setupAnimation() {
        let shakeAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        shakeAnimation.duration = 0.2
        shakeAnimation.fromValue = self.animationFromValue
        shakeAnimation.toValue = 1.1
        shakeAnimation.autoreverses = false
        self.animate = shakeAnimation
    }
    
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    
    public func cl_resetDefaultProps() {
        self.common()
    }

    @available(*, deprecated, message: "Use 'cl_reset' instead.")
    func reset() {
        self.common()
    }
    func common() {
        self.successImage = UIImage(named: "ic_toast_success", in: BundleUtil.getCurrentBundle(), compatibleWith: nil)
        self.failImage = UIImage(named: "icon_sign", in: BundleUtil.getCurrentBundle(), compatibleWith: nil)
        
        self.textAlignment = .center
        self.mainColor = UIColor.black
        self.supportAnimate = true
        self.setupAnimation()
    }
    
    public func cl_resetInputProps() {
        self.maxLength = nil
        self.allowEmoji = nil
        self.onlyNumberAndPoint = nil
        self.pointLength = nil
        self.onlyNumber = nil
    }
    // 再次开启动画
    public func cl_resetSetupAnimation() {
        self.setupAnimation()
    }
    func add(_ toast: CLDialogUtil) {
        self.queue.addOperation(toast)
    }
    public func cancelAll() {
        self.queue.cancelAllOperations()
    }
}
