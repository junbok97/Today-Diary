//
//  Contents.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/08.
//

import UIKit

enum AutoLayoutOffset {
    static let defaultOffset: CGFloat = 12.0
    static let defaultInset: CGFloat = 4.0
}

enum MainViewControllerContents {
    static let navigationItemTitle = "Diary"
    static let calendarHeaderDateFormat = "YYYY년 M월"
    static let calendarHeight: CGFloat = 300
}

enum CreateViewControllerContents {
    static let contentsTextViewPlaceHolder = "Pleas Insert Content ..."
    static let titleTextFieldPlaceHolder = "Title"
    static let navigationItemTitle = "Write Diary"
    static let rightBarButtonItemTitle = "Save"
    static let textFieldHeight: CGFloat = 65.0
}


enum DetailViewControllerContents {
    static let navigationItemTitle = "Detail Diary"
    static let rightBarButtonItemTitle = "Edit"
    static let leftBarButtonItemImage =  UIImage(systemName: "chevron.backward")
}
