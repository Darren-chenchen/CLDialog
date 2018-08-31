//
//  CLDialog.swift
//  CLDialog
//
//  Created by darren on 2018/8/29.
//  Copyright © 2018年 陈亮陈亮. All rights reserved.
//

import UIKit

public class CLDialog: NSObject {
    /// 普通弹框
    public static func cl_show(
                               title: String? = nil,
                               msg: String? = nil,
                               leftActionTitle: String?,
                               rightActionTitle: String?,
                               leftHandler: (()->())? = nil,
                               rightHandler:(()->())? = nil) {
        _ = CLDialogUtil.init(title: title, msg: msg, leftActionTitle: leftActionTitle, rightActionTitle: rightActionTitle, leftHandler: leftHandler, rightHandler: rightHandler,type: CLDialogUtilType.normal)
        
    }
    /// 带图片
    public static func cl_showImg(
                               success: Bool? = nil,
                               msg: String? = nil,
                               leftActionTitle: String?,
                               rightActionTitle: String?,
                               leftHandler: (()->())? = nil,
                               rightHandler:(()->())? = nil) {
        _ = CLDialogUtil.init(msg: msg, leftActionTitle: leftActionTitle, rightActionTitle: rightActionTitle, leftHandler: leftHandler, rightHandler: rightHandler,success: success,type: CLDialogUtilType.image)
    }
    
    public static func cl_showInput(
                                  msg: String? = nil,
                                  leftActionTitle: String?,
                                  rightActionTitle: String?,
                                  leftHandler: ((String)->())? = nil,
                                  rightHandler:((String)->())? = nil) {
        _ = CLDialogUtil.init(msg: msg, leftActionTitle: leftActionTitle, rightActionTitle: rightActionTitle, leftHandler: leftHandler, rightHandler: rightHandler, type: CLDialogUtilType.input)
    }
}
