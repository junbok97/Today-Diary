//
//  CreateCoorinator.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit

protocol CreateCoorinator: Coordinator {
    var parentCoordinator: MainCoordinator? { get }
    
    func startCreate(date: Date)
    func finish()
    func startEdit(diary: Diary)
    func saveFinish()
}

final class DefaultCreateCoorinator: CreateCoorinator {
    
    weak var parentCoordinator: MainCoordinator?
    var navi: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    func start() {}

    init(navi: UINavigationController) {
        self.navi = navi
    }

    func startCreate(date: Date) {
        let viewModel = CreateViewModel(date: date, diary: nil)
        let createViewController = CreateViewController(viewModel: viewModel)
        createViewController.coordinator = self
        navi.pushViewController(createViewController, animated: false)
    }
    
    func finish() {
        parentCoordinator?.finishChild(self)
    }
    
    func startEdit(diary: Diary) {
        let viewModel = CreateViewModel(diary: diary)
        let createViewController = CreateViewController(viewModel: viewModel)
        createViewController.coordinator = self
        navi.pushViewController(createViewController, animated: false)
    }
    
    func saveFinish() {
        navi.popViewController(animated: false)
        parentCoordinator?.finishChild(self)
    }
    
}
