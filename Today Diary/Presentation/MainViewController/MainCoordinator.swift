//
//  MainCoordinator.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit

protocol MainCoordinator: Coordinator {
    func showCreateViewController(date: Date)
    func showDetailViewController(diary: Diary)
    func showEditViewController(diary: Diary)
    func finishChild(_ child: Coordinator)
}

final class DefaultMainCoordinator: MainCoordinator {
    // TODO: 완성 중 ..
//    let mainViewModel = MainViewModel()
    var childCoordinators: [Coordinator] = []
    
    var navi: UINavigationController
    
    init(navi: UINavigationController) {
        self.navi = navi
    }
    
    func start() {
        let mainViewController = MainViewController()
        mainViewController.coordinator = self
//        mainViewController.bind(mainViewModel)
        navi.pushViewController(mainViewController, animated: false)
    }
    
    func showCreateViewController(date: Date) {
        let child = DefaultCreateCoorinator(navi: self.navi)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.startCreate(date: date)
    }
    
    func showEditViewController(diary: Diary) {
        let child = DefaultCreateCoorinator(navi: self.navi)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.startEdit(diary: diary)
    }
    
    func showDetailViewController(diary: Diary) {
        let child = DefaultDetailCoordinator(navi: self.navi)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(diary: diary)
    }
    
    func finishChild(_ child: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0 !== child
        }
    }

}
