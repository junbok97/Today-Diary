//
//  Coordinator.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navi: UINavigationController { get set }
 
    func start()
    
    init(navi: UINavigationController)
}
