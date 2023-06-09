//
//  DiaryManager.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import Foundation

final class DiaryManager {
    
    static let shared = DiaryManager()
    
    private var diaryList: [Diary] = [] { didSet { diaryList.sort { $0.date < $1.date } } }
    
    private init() { self.diaryList = UserDefaults.standard.diarys }
    
    func queryDiary(_ date: Date) -> [Diary] {
        return diaryList.filter { $0.date == date.toString() }
    }
    
    func addDiray(_ diary: Diary) {
        diaryList.append(diary)
        saveDiary()
    }
    
    func deleteDiary(_ target: Diary) {
        for (index, diary) in diaryList.enumerated() {
            if target.id == diary.id {
                diaryList.remove(at: index)
                break
            }
        }
        saveDiary()
    }
    
    func editDiary(_ target: Diary) {
        for (index, diary) in diaryList.enumerated() {
            if target.id == diary.id {
                diaryList[index] = target
                saveDiary()
                return
            }
        }
        diaryList.append(target)
        saveDiary()
    }

    
    func getDiary(_ id: String) -> Diary? {
        for diary in diaryList {
            if diary.id == id {
                return diary
            }
        }
        return nil
    }
    
    private func saveDiary() {
        Task { UserDefaults.standard.diarys = diaryList }
    }
}
