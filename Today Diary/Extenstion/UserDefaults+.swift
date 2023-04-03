//
//  UserDefaults+.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case diarys
    }
    
    var diarys: [Diary] {
        get {
            guard let data = UserDefaults.standard.data(forKey: Key.diarys.rawValue) else { return [] }
            return (try? PropertyListDecoder().decode([Diary].self, from: data)) ?? []
        }
        
        set {
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(newValue), forKey: Key.diarys.rawValue)
        }
    }
    
    func getDiary(key: String) {
        
    }
}
