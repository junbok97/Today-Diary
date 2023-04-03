//
//  DetailViewModel.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/03.
//

import UIKit


struct DetailViewModel {

    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    func getDiary() -> Diary {
        DiaryManager.shared.getDiary(id) ?? Diary(title: "오류", content: "오류가 발생했습니다.", date: Date())
    }
    
}
