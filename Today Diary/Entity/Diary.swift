//
//  Diary.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import UIKit

struct Diary: Codable {
    
    let id: String
    let date: String
    var title: String
    var contents: String
    
    init(title: String, contents: String, date: Date) {
        self.id = UUID().uuidString
        self.title = title
        self.contents = contents
        self.date = DateFormatter().toString(date: date)
    }
}
