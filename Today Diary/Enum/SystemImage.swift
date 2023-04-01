//
//  SystemImage.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import UIKit

enum SystemImage: String {
    case plus

    var image: UIImage? { return UIImage(systemName: self.rawValue) }

}

