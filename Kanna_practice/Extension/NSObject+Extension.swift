//
//  NSObject+Extension.swift
//  Kanna_practice
//
//  Created by AlexandraTsai on 2021/9/3.
//

import UIKit

extension NSObject {
    /// name of class
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    /// name of class
    var nameOfClass: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}
