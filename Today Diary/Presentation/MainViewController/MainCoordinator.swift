//
//  MainCoordinator.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit

protocol MainCoordinator: Coordinator {
    func showCreateViewController(_ viewModel: CreateViewModel)
    func showDetailViewController(_ viewModel: DetailViewModel)
    func finishChild(_ child: Coordinator)
}

final class DefaultMainCoordinator: MainCoordinator {
    let mainViewModel = MainViewModel()
    var childCoordinators: [Coordinator] = []
    
    var navi: UINavigationController
    
    init(navi: UINavigationController) {
        self.navi = navi
    }
    
    func start() {
        let mainViewController = MainViewController()
        mainViewController.coordinator = self
        mainViewController.bind(mainViewModel)
        navi.pushViewController(mainViewController, animated: false)
    }
    
    func showCreateViewController(_ viewModel: CreateViewModel) {
        let child = DefaultCreateCoorinator(navi: self.navi)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(viewModel)
    }
        
    func showDetailViewController(_ viewModel: DetailViewModel) {
        let child = DefaultDetailCoordinator(navi: self.navi)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(viewModel)
    }
    
    func finishChild(_ child: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0 !== child
        }
    }

}
