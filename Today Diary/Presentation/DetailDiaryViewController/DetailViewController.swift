//
//  DetailViewController.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit
import RxSwift

final class DetailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let barbutton =  UIBarButtonItem(
            image: DetailViewControllerContents.leftBarButtonItemImage,
            style: .plain,
            target: self,
            action: #selector(didTappedLeftBarButton)
        )
        barbutton.tintColor = .label
        return barbutton
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let barbutton = UIBarButtonItem(
            title: DetailViewControllerContents.rightBarButtonItemTitle,
            style: .plain,
            target: self,
            action: nil
        )
        barbutton.tintColor = .label
        return barbutton
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        [titleLabel, contentLabel].forEach { view.addSubview($0) }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .titleFont()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .contentFont()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var viewModel: DetailViewModel!
    weak var coordinator: DetailCoordinatorProtocol?
    
    static func create(
        _ viewModel: DetailViewModel,
        _ coordinator: DetailCoordinator
    ) -> DetailViewController {
        let vc = DetailViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func bind() {
        rightBarButtonItem.rx.tap
            .bind(to: viewModel.editButtonTapped)
            .disposed(by: disposeBag)    
        
        viewModel.sendDiary
            .drive(self.rx.diary)
            .disposed(by: disposeBag)
        
        viewModel.showCreateViewController
            .emit(to: self.rx.showCreateViewController)
            .disposed(by: disposeBag)
    }

}

// MARK: - setup
private extension DetailViewController {
    func attribute() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func layout() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AutoLayoutOffset.defaultOffset),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AutoLayoutOffset.defaultOffset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AutoLayoutOffset.defaultOffset),
            
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AutoLayoutOffset.defaultOffset),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AutoLayoutOffset.defaultOffset)
        ])
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
    }
    
    @objc func didTappedLeftBarButton() {
        coordinator?.finish()
    }
}


extension Reactive where Base: DetailViewController {
    var diary: Binder<Diary> {
        return Binder(base) { base, diary in
            base.titleLabel.text = diary.title
            base.navigationItem.title = diary.date
            base.contentLabel.text = diary.contents
        }
    }
    
    var showCreateViewController: Binder<CreateViewModel> {
        return Binder(base) { base, viewModel in
            base.coordinator?.showCreateViewController(viewModel)
        }
    }
}
