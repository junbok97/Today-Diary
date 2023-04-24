//
//  UITableViewCellRegister.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import UIKit

protocol UITableViewCellRegister {
    
    // cellId
    static var cellId: String { get }
    // xib파일로 CustomCell을 만들었는지 유무
    static var isFromNib: Bool { get }
    
    // CustomCell 등록
    static func register(target: UITableView)
    // CustomCell 꺼내오기
    static func dequeueReusableCell(target: UITableView, indexPath: IndexPath?) -> Self
    
}

extension UITableViewCellRegister where Self: UITableViewCell {
    
    // TableView에 CustomCell 등록
    static func register(target: UITableView) {
        // xib파일로 생성한 Cell이라면
        if self.isFromNib { target.register(UINib(nibName: self.cellId, bundle: nil), forCellReuseIdentifier: self.cellId) }
        // 코드로만 생성한 Cell이라면
        else { target.register(Self.self, forCellReuseIdentifier: self.cellId) }
    }
    
    // CustomCell 꺼내오기
    static func dequeueReusableCell(target: UITableView, indexPath: IndexPath?) -> Self {
        
        let cell: UITableViewCell?
        
        // indexPath가 있을 때
        if let indexPath = indexPath {
            cell = target.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        }
        // indexPath가 없을 때
        else { cell = target.dequeueReusableCell(withIdentifier: self.cellId) }
        
        guard let cell = cell as? Self else { fatalError("Error! \(self.cellId)" ) }
        
        return cell
    }
}
