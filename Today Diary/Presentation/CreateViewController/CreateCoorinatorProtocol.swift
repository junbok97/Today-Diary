//
//  CreateCoorinator.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit

protocol CreateCoorinatorProtocol: CoordinatorProtocol {
    var parentCoordinator: MainCoordinatorProtocol? { get }
    func start(_ viewModel: CreateViewModel)
    func finish()
}

final class CreateCoorinator: CreateCoorinatorProtocol {
    
    weak var parentCoordinator: MainCoordinatorProtocol?
    var navi: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    func start() {}

    init(navi: UINavigationController) {
        self.navi = navi
    }

    func start(_ viewModel: CreateViewModel) {
        let createViewController = CreateViewController()
        createViewController.bind(viewModel)
        createViewController.coordinator = self
        navi.pushViewController(createViewController, animated: false)
    }
    
    func finish() {
        navi.popViewController(animated: false)
        parentCoordinator?.finishChild(self)
    }
    
    
}
