//
//  MainViewController.swift
//  Today Diary
//
//  Created by 이준복 on 2023/03/25.
//

import FSCalendar
import UIKit

final class MainViewController: UIViewController {
    
    private lazy var calender: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.delegate = self
        calendar.dataSource = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(calender)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        
    }

}

// MARK: - setup
private extension MainViewController {
    func attribute() {
        navigationItem.title = "Diary"
        
    }
    
    func layout() {
        [calender, tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            calender.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calender.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calender.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calender.heightAnchor.constraint(equalToConstant: 300),
            
            tableView.topAnchor.constraint(equalTo: calender.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
    }
}

// MARK: - FSCalendarDataSource
extension MainViewController: FSCalendarDataSource {
    
}

// MARK: - FSCalendarDelegate
extension MainViewController: FSCalendarDelegate {
    
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
}
