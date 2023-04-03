//
//  Date+.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import Foundation

extension Date{
    
    static  let calendar = Calendar.current
    static  let dateFormatter = DateFormatter()
    
    var dateComponets: DateComponents {
        return Date.calendar.dateComponents([.year, .month, .day], from: self)
    }
    
    // 구조체 실패가능 생성자로 구현
    init?(y year: Int, m month: Int, d day: Int) {
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        guard let date = Calendar.current.date(from: components) else {
            return nil  // 날짜 생성할 수 없다면 nil리턴
        }
        
        self = date      //구조체이기 때문에, self에 새로운 인스턴스를 할당하는 방식으로 초기화가능
    }
    
    func setCurrentTime() -> Date {
        let current = Date.calendar.dateComponents([.hour, .minute, .second], from: Date())
        var components = Date.calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(current.hour, for: .hour)
        components.setValue(current.minute, for: .minute)
        components.setValue(current.second, for: .second)
        return Date.calendar.date(from: components)!
    }
    
    func firstOfDay() -> Date {
        let components = Date.calendar.dateComponents([.year, .month, .day], from: self)
        return Date.calendar.date(from: components)!
    }
    func lastOfDay() -> Date {
        var components = Date.calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(23, for: .hour)
        components.setValue(59, for: .minute)
        components.setValue(59, for: .second)
        return Date.calendar.date(from: components)!
    }
    
    func firstOfWeek() -> Date {
        let components = Date.calendar.dateComponents([.year, .month, .weekday], from: self)
        let first = self - TimeInterval((components.weekday! - 1) * 24 * 60 * 60)
        return first.firstOfDay()
    }
    
    func lastOfWeek() -> Date {
        let components = Date.calendar.dateComponents([.year, .month, .weekday], from: self)
        let last = self + TimeInterval((7 - components.weekday!) * 24 * 60 * 60)
        return last.lastOfDay()
    }
    
    func firstOfMonth() -> Date {
        let components = Date.calendar.dateComponents([.year, .month], from: self)
        return Date.calendar.date(from: components)!
    }
    
    func lastOfMonth() -> Date {
        let lastDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        var components = Date.calendar.dateComponents([.year, .month], from: self)
        let lastDay = lastDays[components.month! - 1]
        components.setValue(lastDay, for: .day)
        components.setValue(23, for: .hour)
        components.setValue(59, for: .minute)
        components.setValue(59, for: .second)
        return Date.calendar.date(from: components)!
    }
    
    func toStringMonth() -> String {
        Date.dateFormatter.dateFormat = "yyyy-MM"
        return Date.dateFormatter.string(from: self)
    }
    
    func toStringDate() -> String {
        Date.dateFormatter.dateFormat = "yyyy-MM-dd"
        return Date.dateFormatter.string(from: self)
    }
    
    func toStringDateTime() -> String {
        Date.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return Date.dateFormatter.string(from: self)
    }
    
    

}
