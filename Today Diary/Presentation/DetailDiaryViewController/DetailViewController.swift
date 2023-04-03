//
//  DetailViewController.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/02.
//

import UIKit

final class DetailViewController: UIViewController {
    
    let id: String
    let diaryManager = DiaryManager.shared
    var coordinator: DetailCoordinator?
    
    var diary: Diary? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.text = self?.diary!.title
                self?.dateLabel.text = self?.diary!.date
                self?.contentLabel.text = self?.diary!.content
            }
        }
    }
    
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let barbutton = UIBarButtonItem(title: "edit", style: .plain, target: self, action: #selector(editButtonTapped))
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
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .subTitleFont()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .titleFont()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .contentFont()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.diary = diaryManager.getDiary(id)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    deinit {
        coordinator?.finish()
        print("detaklViewController")
    }
}

// MARK: - setup
private extension DetailViewController {
    func attribute() {
        navigationItem.title = "Detail Diary"
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

// MARK: - @objc
private extension DetailViewController {
    @objc func editButtonTapped() {
        coordinator?.showEditViewController(diary: diary!)
    }
}
