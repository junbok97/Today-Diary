//
//  DetailViewController.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit
import RxSwift

final class DetailViewController: UIViewController {
    
    var coordinator: DetailCoordinator?
    let disposeBag = DisposeBag()
    
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let barbutton = UIBarButtonItem(title: DetailViewControllerContents.rightBarButtonItemTitle, style: .plain, target: self, action: nil)
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
        [titleLabel, dateLabel, contentLabel].forEach { view.addSubview($0) }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .subTitleFont()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func bind(_ viewModel: DetailViewModel) {
        editBarButtonItem.rx.tap
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
        navigationItem.title = DetailViewControllerContents.navigationItemTitle
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    func layout() {
        view.addSubview(scrollView)
        
        let inset: CGFloat = 4.0
        let offset: CGFloat = 12.0
        
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
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: inset),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: offset),
            contentLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset)
        ])
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        
    }
}


extension Reactive where Base: DetailViewController {
    var diary: Binder<Diary> {
        return Binder(base) { base, diary in
            base.titleLabel.text = diary.title
            base.dateLabel.text = diary.date
            base.contentLabel.text = diary.contents
        }
    }
    
    var showCreateViewController: Binder<CreateViewModel> {
        return Binder(base) { base, viewModel in
            base.coordinator?.showCreateViewController(viewModel)
        }
    }
}
