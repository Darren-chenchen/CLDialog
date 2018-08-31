//
//  CLDialogInputView.swift
//  CLDialog
//
//  Created by darren on 2018/8/30.
//  Copyright © 2018年 陈亮陈亮. All rights reserved.
//

import UIKit

typealias CLDialogInputViewClouse = (String)->()

class CLDialogInputView: UIView {
    
    var myGrayColor = UIColor.init(red: 120/255, green: 120/255, blue: 120/255, alpha: 120/255)
    
    lazy var msgLabel: UILabel = {
        let title = UILabel.init(frame: CGRect.zero)
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    lazy var textView: CLTextView = {
        let text = CLTextView.init(frame: CGRect.zero)
        text.placehoder = "请输入..."
        text.backgroundColor = UIColor.groupTableViewBackground
        text.layer.cornerRadius = 5
        return text
    }()
    lazy var leftBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(clickLeftbtn), for: .touchUpInside)
        return btn
    }()
    lazy var rightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(clickRightbtn), for: .touchUpInside)
        return btn
    }()
    lazy var lineViewRow: UIView = {
        let line = UIView.init(frame: CGRect.zero)
        line.backgroundColor = UIColor.groupTableViewBackground
        return line
    }()
    lazy var lineView: UIView = {
        let line = UIView.init(frame: CGRect.zero)
        line.backgroundColor = UIColor.groupTableViewBackground
        return line
    }()
    lazy var bottomView: UIView = {
        let bottom = UIView.init(frame: CGRect.zero)
        bottom.backgroundColor = UIColor.clear
        return bottom
    }()
    
    open var msg: String? {
        get { return self.msgLabel.text }
        set { self.msgLabel.text = newValue }
    }
    open var leftActionTitle: String? {
        get { return self.leftBtn.currentTitle }
        set { self.leftBtn.setTitle(newValue, for: .normal)  }
    }
    open var rightActionTitle: String? {
        get { return self.rightBtn.currentTitle }
        set { self.rightBtn.setTitle(newValue, for: .normal)  }
    }
    
    open var leftHandler: CLDialogInputViewClouse?
    open var rightHandler: CLDialogInputViewClouse?
    
    var keyBoardHeight: CGFloat = 0
    
    var superWidth = KScreenWidth
    var superHeight = KScreenHeight
    var textHeight: CGFloat = 33
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickTitle)))

        initView()
        initEventHendle()
    }
    @objc func clickTitle() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    func initEventHendle() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        ScreenTools.share.screenClouse = { [weak self] (orientation) in
            self?.setNeedsLayout()
        }
        
        self.textView.textChangeClouse = {[weak self] (textHeight) in
            
            self?.textHeight = textHeight
            self?.setNeedsLayout()
            self?.textView.isScrollEnabled = false
        }
    }
    @objc func keyboardWillShow(aNotification: Notification) {
        let userInfo = aNotification.userInfo
        guard let info = userInfo else {
            return
        }
        let aValue = info[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let keyboardRect = aValue?.cgRectValue
        let height = keyboardRect?.size.height
        self.keyBoardHeight = height ?? 0
        self.setNeedsLayout()
    }
    @objc func keyboardWillHide(aNotification: Notification) {
        self.keyBoardHeight = 0
        self.setNeedsLayout()
    }
    func initView() {
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.white
        self.addSubview(self.textView)
        self.addSubview(self.msgLabel)
        self.addSubview(self.lineViewRow)
        self.addSubview(self.bottomView)
        self.bottomView.addSubview(self.leftBtn)
        self.bottomView.addSubview(self.rightBtn)
        self.bottomView.addSubview(self.lineView)
    }
    
    @objc func clickLeftbtn() {
        CLDialogManager.share.resetInputProps()
        if self.leftHandler != nil {
            self.leftHandler!(self.dealText())
        }
    }
    @objc func clickRightbtn() {
        CLDialogManager.share.resetInputProps()
        if self.rightHandler != nil {
            self.rightHandler!(self.dealText())
        }
    }
    // 如果出现3.的情况，就把小数点去掉
    func dealText() -> String {
        var tempText = ""
        let arr = self.textView.text.components(separatedBy: ".")
        if arr.count == 2 {
            if arr.last == nil || arr.last == "" {
                tempText = arr.first ?? ""
            }
        } else {
            tempText = self.textView.text
        }
        return tempText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
                
        self.superWidth = KScreenWidth
        self.superHeight = KScreenHeight
        
        let constraintSize = CGSize(
            width: dialogWidth - 20,
            height: CGFloat.greatestFiniteMagnitude
        )
        let msgSize = self.msgLabel.sizeThatFits(constraintSize)
        self.msgLabel.preferredMaxLayoutWidth = dialogWidth - 20
        
        msgSize.height > 0 ? (self.msgLabel.frame = CGRect.init(x: 10, y: 20, width: dialogWidth-20, height: msgSize.height)):(self.msgLabel.frame = CGRect.zero)
        self.textView.frame = CGRect.init(x: 10, y: self.msgLabel.frame.maxY + 20, width: dialogWidth-20, height: textHeight)
        self.lineViewRow.frame = CGRect.init(x: 0, y: self.textView.frame.maxY + 20, width: dialogWidth, height: 1)
        self.bottomView.frame = CGRect.init(x: 0, y: self.lineViewRow.frame.maxY, width: dialogWidth, height: 50)
        if self.leftActionTitle == nil || self.leftActionTitle?.count == 0 {
            self.leftBtn.frame = CGRect.zero
            self.lineView.frame = CGRect.zero
            self.rightBtn.frame = self.bottomView.bounds
            
            self.frame = CGRect.init(x: 0.5*(superWidth - dialogWidth), y: 0.5*(superHeight - (self.bottomView.frame.maxY)), width: dialogWidth, height: self.bottomView.frame.maxY)
            self.rightBtn.setTitleColor(CLDialogManager.share.mainColor, for: .normal)
            return
        }
        if self.rightActionTitle == nil || self.rightActionTitle?.count == 0 {
            self.rightBtn.frame = CGRect.zero
            self.lineView.frame = CGRect.zero
            self.leftBtn.frame = self.bottomView.bounds
            
            self.frame = CGRect.init(x: 0.5*(superWidth - dialogWidth), y: 0.5*(superHeight - (self.bottomView.frame.maxY)), width: dialogWidth, height: self.bottomView.frame.maxY)
            self.leftBtn.setTitleColor(CLDialogManager.share.mainColor, for: .normal)
            return
        }
        if self.rightActionTitle != nil && self.leftActionTitle != nil {
            self.leftBtn.frame = CGRect.init(x: 0, y: 0, width: dialogWidth*0.5-0.5, height: self.bottomView.frame.height)
            self.rightBtn.frame = CGRect.init(x: dialogWidth*0.5+0.5, y: 0, width: dialogWidth*0.5-0.5, height: self.bottomView.frame.height)
            self.lineView.frame = CGRect.init(x: dialogWidth*0.5-0.5, y: 0, width: 1, height: self.bottomView.frame.height)
        }
        
        self.frame = CGRect.init(x: 0.5*(superWidth - dialogWidth), y: 0.5*(superHeight - (self.bottomView.frame.maxY)), width: dialogWidth, height: self.bottomView.frame.maxY)
        if self.keyBoardHeight > 0 {
            self.frame = CGRect.init(x: 0.5*(superWidth - dialogWidth), y: superHeight-self.keyBoardHeight-self.bottomView.frame.maxY, width: dialogWidth, height: self.bottomView.frame.maxY)
        }
        self.rightBtn.setTitleColor(CLDialogManager.share.mainColor, for: .normal)
        self.leftBtn.setTitleColor(myGrayColor, for: .normal)
    }
}
