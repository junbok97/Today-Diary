//
//  DetailCoordinator.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit
import RxSwift
import RxCocoa

protocol DetailCoordinatorProtocol: CoordinatorProtocol {
    var parentCoordinator: MainCoordinatorProtocol? { get }
    func start(_ viewModel: DetailViewModel)
    func showCreateViewController(_ viewModel: CreateViewModel)
    func finish()
}

final class DetailCoordinator: DetailCoordinatorProtocol {
    
    weak var parentCoordinator: MainCoordinatorProtocol?
    
    var childCoordinators: [CoordinatorProtocol] = []
    
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
    
    func showCreateViewController(_ viewModel: CreateViewModel) {
        parentCoordinator?.showCreateViewController(viewModel)
    }


}
