//
//  Diary.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import UIKit
import RxSwift

struct Diary: Codable {
    
    // TODO: id와 date private로 변경예정
    let id: String
    let date: String
    var title: String
    var content: String
    
    init(title: String, content: String, date: Date) {
        self.id = UUID().uuidString
        self.title = title
        self.content = content
        self.date = DateFormatter().toString(date: date)
    }
}
