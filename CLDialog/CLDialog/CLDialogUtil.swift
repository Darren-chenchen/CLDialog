//
//  CLDialogUtil.swift
//  CLDialog
//
//  Created by darren on 2018/8/29.
//  Copyright © 2018年 陈亮陈亮. All rights reserved.
//

import UIKit

enum CLDialogUtilType {
    case normal  // 类似系统的弹框
    case image  // 带有图片的弹框
    case input // 可输入文字的弹框
}

class CLDialogUtil: Operation {
    
    lazy var coverView: UIView = {
        let cover = UIView.init(frame: CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        cover.alpha = 0.1
        cover.backgroundColor = UIColor.black
        return cover
    }()
    
    private var _executing = false
    override open var isExecuting: Bool {
        get {
            return self._executing
        }
        set {
            self.willChangeValue(forKey: "isExecuting")
            self._executing = newValue
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished = false
    override open var isFinished: Bool {
        get {
            return self._finished
        }
        set {
            self.willChangeValue(forKey: "isFinished")
            self._finished = newValue
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    var normalView: CLDialogNormalView = CLDialogNormalView()   // 默认
    var imgView: CLDialogImageView = CLDialogImageView()
    var inputView: CLDialogInputView = CLDialogInputView()
    
    var superComponent: UIView = (UIApplication.shared.keyWindow ?? UIView())
    var type = CLDialogUtilType.normal
    var success: Bool = false
    
    init(
        title: String? = nil,
        msg: String? = nil,
        leftActionTitle: String?,
        rightActionTitle: String?,
        leftHandler: (()->())? = nil,
        rightHandler:(()->())? = nil,
        success: Bool? = nil,
        type: CLDialogUtilType? = nil) {
        
        super.init()
        
        self.success = success ?? false
        self.type = type ?? CLDialogUtilType.normal
        
        if self.type == .normal {
            self.setupNormalView(title: title,msg: msg,leftActionTitle: leftActionTitle,rightActionTitle: rightActionTitle,leftHandler: leftHandler,rightHandler:rightHandler)
        }
        if self.type == .image {
            self.setupImageView(msg: msg,leftActionTitle: leftActionTitle,rightActionTitle: rightActionTitle,leftHandler: leftHandler,rightHandler:rightHandler)
        }

        self.commonUI()
    }
    /// 输入框类型
    init(
        msg: String? = nil,
        leftActionTitle: String?,
        rightActionTitle: String?,
        leftHandler: ((String)->())? = nil,
        rightHandler:((String)->())? = nil,
        type: CLDialogUtilType? = nil) {
        
        super.init()
        
        self.type = type ?? CLDialogUtilType.input

        self.setupInputView(msg: msg,leftActionTitle: leftActionTitle,rightActionTitle: rightActionTitle,leftHandler: leftHandler,rightHandler:rightHandler)
        
        self.commonUI()
    }
    
    func commonUI() {
        // 单利队列中每次都加入一个新建的Operation
        CLDialogManager.share.add(self)
        
        self.superComponent.addSubview(self.coverView)
        
        self.coverView.translatesAutoresizingMaskIntoConstraints = false
        self.superComponent.addConstraints([
            NSLayoutConstraint.init(item: self.coverView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.superComponent, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.coverView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.superComponent, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.coverView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.superComponent, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.coverView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.superComponent, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0),
            ])
    }
    
    func setupNormalView(title: String? = nil,
                         msg: String? = nil,
                         leftActionTitle: String?,
                         rightActionTitle: String?,
                         leftHandler: (()->())? = nil,
                         rightHandler:(()->())? = nil) {
        self.normalView.title = title
        self.normalView.msg = msg
        self.normalView.leftActionTitle = leftActionTitle
        self.normalView.rightActionTitle = rightActionTitle
        self.normalView.leftHandler = {() in
            self.dismiss()
            if leftHandler != nil {
                leftHandler!()
            }
        }
        self.normalView.rightHandler = {() in
            self.dismiss()
            if rightHandler != nil {
                rightHandler!()
            }
        }
    }
    
    func setupImageView(msg: String? = nil,
                        leftActionTitle: String?,
                        rightActionTitle: String?,
                        leftHandler: (()->())? = nil,
                        rightHandler:(()->())? = nil) {
        self.imgView.msg = msg
        self.imgView.leftActionTitle = leftActionTitle
        self.imgView.rightActionTitle = rightActionTitle
        self.imgView.leftHandler = {() in
            self.dismiss()
            if leftHandler != nil {
                leftHandler!()
            }
        }
        self.imgView.rightHandler = {() in
            self.dismiss()
            if rightHandler != nil {
                rightHandler!()
            }
        }
    }
    func setupInputView(msg: String? = nil,
                        leftActionTitle: String?,
                        rightActionTitle: String?,
                        leftHandler: ((String)->())? = nil,
                        rightHandler:((String)->())? = nil) {
        self.inputView.msg = msg
        self.inputView.leftActionTitle = leftActionTitle
        self.inputView.rightActionTitle = rightActionTitle
        self.inputView.leftHandler = {(text) in
            self.dismiss()
            if leftHandler != nil {
                leftHandler!(text)
            }
        }
        self.inputView.rightHandler = {(text) in
            self.dismiss()
            if rightHandler != nil {
                rightHandler!(text)
            }
        }
    }

    open override func cancel() {
        super.cancel()
        self.dismiss()
    }
    override func start() {
        let isRunnable = !self.isFinished && !self.isCancelled && !self.isExecuting
        guard isRunnable else { return }
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.start()
            }
            return
        }
        main()
    }
    override func main() {
        self.isExecuting = true
        
        DispatchQueue.main.async {
            
            if self.type == .normal {
                self.showNormalView()
            }
            if self.type == .image {
                self.showImageView()
            }
            if self.type == .input {
                self.showInputView()
            }
        }
    }
    
    func showNormalView() {
        self.superComponent.addSubview(self.normalView)
        self.normalView.msgLabel.textAlignment = CLDialogManager.share.textAlignment
        self.normalView.setNeedsLayout()
        
        if CLDialogManager.share.supportAnimate {
            self.normalView.layer.add(CLDialogManager.share.animate, forKey: nil)
        }
    }
    func showImageView() {
        self.superComponent.addSubview(self.imgView)
        self.imgView.msgLabel.textAlignment = CLDialogManager.share.textAlignment
        if self.success {
            self.imgView.iconView.image = CLDialogManager.share.successImage
        } else {
            self.imgView.iconView.image = CLDialogManager.share.failImage
        }
        self.normalView.setNeedsLayout()

        if CLDialogManager.share.supportAnimate {
            self.imgView.layer.add(CLDialogManager.share.animate, forKey: nil)
        }
    }
    func showInputView() {
        self.superComponent.addSubview(self.inputView)
        self.inputView.msgLabel.textAlignment = CLDialogManager.share.textAlignment
//        self.inputView.maxLength = CLDialogManager.share.maxLength
//        self.inputView.onlyNumberAndPoint = CLDialogManager.share.onlyNumberAndPoint
//        self.inputView.onlyNumber = CLDialogManager.share.onlyNumber
//        self.inputView.allowEmoji = CLDialogManager.share.allowEmoji
//        self.inputView.pointLength = CLDialogManager.share.pointLength
        self.inputView.setNeedsLayout()
        
        if CLDialogManager.share.supportAnimate {
            self.inputView.layer.add(CLDialogManager.share.animate, forKey: nil)
        }
    }
}

extension CLDialogUtil {
    
    func dismiss() {
        self.coverView.removeFromSuperview()
        self.normalView.removeFromSuperview()
        self.imgView.removeFromSuperview()
        self.inputView.removeFromSuperview()
        self.finish()
    }
    
    func finish() {
        self.isExecuting = false
        self.isFinished = true
        
        if CLDialogManager.share.supportQuene == false {
            CLDialogManager.share.cancelAll()
        }
    }
}
