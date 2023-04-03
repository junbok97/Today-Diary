//
//  UIFont+.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit

extension UIFont {
    
    static func titleFont() -> UIFont {
        .systemFont(ofSize: 35, weight: .medium)
    }
    
    static func subTitleFont() -> UIFont {
        .systemFont(ofSize: 20, weight: .regular)
    }
    
    static func contentFont() -> UIFont {
        .systemFont(ofSize: 20)
    }
    
}


