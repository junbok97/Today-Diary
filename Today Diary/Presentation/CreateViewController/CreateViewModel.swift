//
//  CreateViewModel.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/03.
//

import Foundation

struct CreateViewModel {
    
    private var diary: Diary
    private let isHasDiary: Bool
    
    init(date: Date = Date(), diary: Diary?) {
        if let diary = diary {
            self.diary = diary
            self.isHasDiary = true
        } else {
            self.diary = Diary(title: "", content: "", date: date)
            self.isHasDiary = false
        }
    }
    
    mutating func saveDiary(title: String, content: String) {
        diary.title = title
        diary.content = content
        
        if isHasDiary {
            DiaryManager.shared.editDiary(diary)
        } else {
            DiaryManager.shared.addDiray(diary)
        }
    }
    
    func getDiary() -> Diary {
        return diary
    }
    
}
