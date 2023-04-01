//
//  MainViewController.swift
//  Today Diary
//
//  Created by 이준복 on 2023/03/25.
//

import FSCalendar
import UIKit

final class MainViewController: UIViewController {
    
    private lazy var addDiaryButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: SystemImage.plus.image, style: .done, target: self, action: nil) // TODO: action 추가
        barButton.tintColor = .label
        return barButton
    }()
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        // 전월이나 다음월의 일수를 표현할 것인지
        // ex) 30 31 1 2 3 or 1 2 3
        calendar.placeholderType = .fillHeadTail
        // 달력에 표시되는 헤더
        calendar.appearance.headerTitleColor = .label
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        // 전달 or 다음달의 투명도
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.weekdayTextColor = .label
        calendar.appearance.selectionColor = .label
        calendar.delegate = self
        calendar.dataSource = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    private lazy var diaryList: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(calendar)
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
        navigationItem.rightBarButtonItem = addDiaryButton
    }
    
    func layout() {
        [calendar, diaryList].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 300),
            
            diaryList.topAnchor.constraint(equalTo: calendar.bottomAnchor),
            diaryList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
