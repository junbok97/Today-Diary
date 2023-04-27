//
//  MainCoordinator.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit

protocol MainCoordinatorProtocol: CoordinatorProtocol {
    func showCreateViewController(_ viewModel: CreateViewModel)
    func showDetailViewController(_ viewModel: DetailViewModel)
    func finishChild(_ child: CoordinatorProtocol)
}

final class MainCoordinator: MainCoordinatorProtocol {
    let mainViewModel = MainViewModel()
    var childCoordinators: [CoordinatorProtocol] = []
    
    var navi: UINavigationController
    
    init(navi: UINavigationController) {
        self.navi = navi
    }
    
    func start() {
        let mainViewController = MainViewController.create(mainViewModel, self)
        mainViewController.bind()
        navi.pushViewController(mainViewController, animated: false)
    }
    
    func showCreateViewController(_ viewModel: CreateViewModel) {
        let child = CreateCoorinator(navi: self.navi)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(viewModel)
    }
        
    func showDetailViewController(_ viewModel: DetailViewModel) {
        let child = DetailCoordinator(navi: self.navi)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(viewModel)
    }
    
    func finishChild(_ child: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== child }
        navi.popViewController(animated: false)
    }

}
