//
//  Diary.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import UIKit

struct Diary: Codable {
    // TODO: id와 date private로 변경예정
    let id: String
    let date: Date
    var title: String
    var content: String
    
    init(title: String, content: String) {
        self.id = UUID().uuidString
        self.date = Date()
        self.title = title
        self.content = content
    }
    
    var dateString: String? {
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        
        return myFormatter.string(from: date)
    }
}


