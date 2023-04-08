//
//  CreateCoorinator.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit

protocol CreateCoorinator: Coordinator {
    var parentCoordinator: MainCoordinator? { get }
    func start(_ viewModel: CreateViewModel)
    func finish()
}

final class DefaultCreateCoorinator: CreateCoorinator {
    
    weak var parentCoordinator: MainCoordinator?
    var navi: UINavigationController
    var childCoordinators: [Coordinator] = []
    
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
