//
//  Coordinator.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navi: UINavigationController { get set }
 
    func start()
    
    init(navi: UINavigationController)
}
