//
//  String+Ext.swift
//  CLDialog
//
//  Created by darren on 2018/8/30.
//  Copyright © 2018年 陈亮陈亮. All rights reserved.
//

import UIKit

extension String {
    func mySubString(to index: Int) -> String {
        if index >= self.count {
            return String(self[..<self.index(self.startIndex, offsetBy: self.count)])
        }
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func mySubString(from index: Int) -> String {
        if index >= self.count {
            return String(self[self.index(self.startIndex, offsetBy: self.count)...])
        }
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    
    //range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    
}
