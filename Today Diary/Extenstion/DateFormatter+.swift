//
//  DateFormatter.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import Foundation

extension DateFormatter {
    
    func toString(date: Date) -> String {
        dateFormat = "yyyy-MM-dd"
        return string(from: date)
    }

}
