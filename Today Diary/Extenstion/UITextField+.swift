//
//  UITextField+.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import UIKit

extension UITextField {
    func addPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: self.frame.height))
        
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
