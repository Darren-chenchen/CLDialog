//
//  ViewController.swift
//  CLDialog
//
//  Created by darren on 2018/8/29.
//  Copyright © 2018年 陈亮陈亮. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.1))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
   
    var titleArr = ["标题+内容+2个按钮",
                    "标题+内容+1个按钮",
                    "标题+内容+1个按钮",
                    "内容+1个按钮",
                    "内容+2个按钮",
                    "标题+内容很多+居中",
                    "标题+内容很多+居左",
                    "设置主题色，2个按钮时只设置右边的主题色，1个按钮时显示主题色",
                    "禁止动画显示",
                    "打开动画显示",
                    "自定义动画",
    ]
    var titleArr2 = ["展示默认成功图片", "展示默认失败图片", "自定义图片"]
    
    var titleArr3 = ["展示可输入文本的弹框",
                     "限制最大长度10",
                     "限制不可输入表情符号",
                     "只能输入数字和小数点，小数点后保留2位",
                     "只能输入数字和小数点，小数点后保留3位,最大长度限制10",
                     "自定义正则，只能输入数字和英文",
                     ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
        }
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint.init(item: self.tableView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.tableView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.tableView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.tableView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0),
            ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return titleArr.count
        }
        if section == 1 {
            return titleArr2.count
        }
        return titleArr3.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID = "ID"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ID)
        }
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        if indexPath.section == 0 {
            cell?.textLabel?.text = titleArr[indexPath.row]
        } else if indexPath.section == 1 {
            cell?.textLabel?.text = titleArr2[indexPath.row]
        }else if indexPath.section == 2 {
            cell?.textLabel?.text = titleArr3[indexPath.row]
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CLDialog的基本使用,类似系统的弹框"
        }
        if section == 1 {
            return "带有图片的弹框"
        }
        if section == 2 {
            return "可输入文本的弹框"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                CLDialogManager.share.mainColor = UIColor.blue
                CLDialog.cl_show(title: "温馨提示", msg: "确定要取消？", leftActionTitle: "确定", rightActionTitle: "取消", leftHandler: {
                    print("点击了左边")
                    CLDialogManager.share.mainColor = UIColor.red
                }) {
                    print("点击了右边")
                    CLDialogManager.share.mainColor = UIColor.red
                }
            } else if indexPath.row == 1 {
                CLDialog.cl_show(title: "温馨提示", msg: "确定要取消？", leftActionTitle: "确定", rightActionTitle: nil, leftHandler: {
                    
                }) {
                    
                }
            }else if indexPath.row == 2 {
                CLDialog.cl_show(title: "温馨提示", msg: "确定要取消？", leftActionTitle: "", rightActionTitle: "确定", leftHandler: {
                    
                }) {
                    
                }
            } else if indexPath.row == 3 {
                CLDialog.cl_show(title: nil, msg: "确定要取消？", leftActionTitle: "", rightActionTitle: "确定", leftHandler: {
                    
                }) {
                    
                }
            } else if indexPath.row == 4 {
                CLDialog.cl_show(title: nil, msg: "确定要取消？", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
                    
                }) {
                    
                }
            } else if indexPath.row == 5 {
                CLDialogManager.share.textAlignment = .center
                CLDialog.cl_show(title: "温馨提示", msg: "内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多123居中显示", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
                    
                }) {
                    
                }
            } else if indexPath.row == 6 {
                CLDialogManager.share.textAlignment = .left
                CLDialog.cl_show(title: "温馨提示", msg: "内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多内容较多123居左显示", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
                }) {
                }
            } else if indexPath.row == 7 {
                CLDialogManager.share.mainColor = UIColor.red
                CLDialog.cl_show(title: "温馨提示", msg: "设置主题色", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
                }) {
                }
            } else if indexPath.row == 8 {
                CLDialogManager.share.supportAnimate = false
                CLDialog.cl_show(title: "温馨提示", msg: "禁止动画", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
                }) {
                }
            } else if indexPath.row == 9 {
                CLDialogManager.share.supportAnimate = true
                CLDialog.cl_show(title: "温馨提示", msg: "打开动画", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
                }) {
                }
            } else if indexPath.row == 10 {
                let shakeAnimation = CABasicAnimation.init(keyPath: "position")
                shakeAnimation.duration = 0.2
                shakeAnimation.fromValue = NSValue.init(cgPoint: CGPoint.init(x: KScreenWidth*0.5, y: 0))
                shakeAnimation.toValue = NSValue.init(cgPoint: CGPoint.init(x: KScreenWidth*0.5, y: KScreenHeight*0.5))
                shakeAnimation.autoreverses = false
                CLDialogManager.share.animate = shakeAnimation
                CLDialog.cl_show(title: "温馨提示", msg: "自定义动画", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: {
                }) {
                }
            }
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                CLDialog.cl_showImg(success: true, msg: "提交成功", leftActionTitle: "知道了", rightActionTitle: nil, leftHandler: nil, rightHandler: nil)
            }
            if indexPath.row == 1 {
                CLDialog.cl_showImg(success: false, msg: "提交失败", leftActionTitle: "知道了", rightActionTitle: "确定", leftHandler: nil, rightHandler: nil)
            }
            if indexPath.row == 2 {
                CLDialogManager.share.successImage = UIImage.init(named: "message_success")
                CLDialog.cl_showImg(success: true, msg: "提交成功", leftActionTitle: "知道了", rightActionTitle: nil, leftHandler: nil, rightHandler: nil)
            }
        }
        
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                CLDialog.cl_showInput(msg: "请输入取消原因", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: { (text) in
                    print(text)
                }) { (text) in
                    print(text)
                }
            }
            if indexPath.row == 1 {
                CLDialogManager.share.maxLength = 10
                CLDialog.cl_showInput(msg: "限制最大长度10", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: { (text) in
                    print(text)
                }) { (text) in
                    print(text)
                }
            }
            if indexPath.row == 2 {
                CLDialogManager.share.allowEmoji = false
                CLDialog.cl_showInput(msg: "禁止输入表情符号", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: { (text) in
                    print(text)
                }) { (text) in
                    print(text)
                }
            }
            if indexPath.row == 3 {
                CLDialogManager.share.onlyNumberAndPoint = true
                CLDialogManager.share.pointLength = 2
                CLDialog.cl_showInput(msg: "只能输入数字和小数点，小数点后保留2位", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: { (text) in
                    print(text)
                }) { (text) in
                    print(text)
                }
            }
            if indexPath.row == 4 {
                CLDialogManager.share.onlyNumberAndPoint = true
                CLDialogManager.share.pointLength = 3
                CLDialogManager.share.maxLength = 10
                CLDialog.cl_showInput(msg: "只能输入数字和小数点，小数点后保留3位,最大长度限制10", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: { (text) in
                    print(text)
                }) { (text) in
                    print(text)
                }
            }
            if indexPath.row == 5 {
                CLDialogManager.share.predicateString = "^[a-z0－9A-Z]*$"
                CLDialog.cl_showInput(msg: "自定义正则，只能输入数字和英文", leftActionTitle: "取消", rightActionTitle: "确定", leftHandler: { (text) in
                    print(text)
                }) { (text) in
                    print(text)
                }
            }
            
            
        }

    }
    
}

