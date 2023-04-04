//
//  DetailCoordinator.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit

protocol DetailCoordinator: Coordinator {
    var parentCoordinator: MainCoordinator? { get }
    func start(_ viewModel: DetailViewModel)
    func showEditViewController(diary: Diary)
    func finish()
}

final class DefaultDetailCoordinator: DetailCoordinator {
    
    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var navi: UINavigationController
    
    func start() {}
    
    init(navi: UINavigationController) {
        self.navi = navi
    }
    
    func start(_ viewModel: DetailViewModel) {
        let detailViewController = DetailViewController()
        detailViewController.bind(viewModel)
        detailViewController.coordinator = self
        navi.pushViewController(detailViewController, animated: false)
    }
    
    func finish() {
        parentCoordinator?.finishChild(self)
    }
    
    func showEditViewController(diary: Diary) {
        parentCoordinator?.showEditViewController(diary: diary)
    }


}
