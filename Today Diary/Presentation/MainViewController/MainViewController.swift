//
//  MainViewController.swift
//  Today Diary
//
//  Created by 이준복 on 2023/03/25.
//

import FSCalendar
import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    var coordinator: MainCoordinator?
//    let selectedDatePublisher = PublishSubject<Date>()
    private let disposeBag = DisposeBag()
    private let diaryManager = DiaryManager.shared
    private var todayDiarys: [Diary] = [] {
        didSet {
            DispatchQueue.main.async {
                self.diaryList.reloadData()
            }
        }
    }
    
    private lazy var addDiaryButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: SystemImage.plus.image, style: .done, target: self, action: #selector(addDiaryButtonTapped)) // TODO: action 추가
        barButton.tintColor = .label
        return barButton
    }()
    
    let diaryListBackgroundView = DiaryListBackgroundView()
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.delegate = self
        calendar.dataSource = self
        // 전월이나 다음월의 일수를 표현할 것인지
        // ex) 30 31 1 2 3 or 1 2 3
        calendar.placeholderType = .none
        // 달력에 표시되는 헤더
        
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        // 전달 or 다음달의 투명도
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        calendar.appearance.headerTitleColor = .label
        calendar.appearance.weekdayTextColor = .label
        calendar.appearance.selectionColor = .label
        calendar.appearance.eventDefaultColor = .red
        calendar.appearance.eventSelectionColor = .red
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.titleSelectionColor = .systemBackground

        calendar.tintColor = .label
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    private lazy var diaryList: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
        tableView.backgroundView = diaryListBackgroundView
        DiaryListCell.register(target: tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTodayDiarys()
        
    }

    // TODO: 완성중 ...
//    func bind(_ viewModel: MainViewModel) {
//        diaryListBackgroundView
//            .bind(viewModel.diaryListBackgroundViewModel)
//
//        selectedDatePublisher
//            .bind(to: viewModel.selectDate)
//            .disposed(by: disposeBag)
//
//        viewModel
//            .diaryListCellData
//            .drive(diaryList.rx.items) { tableView, row, item in
//                let cell = DiaryListCell.dequeueReusableCell(target: tableView, indexPath: nil)
//                cell.setData(diary: item)
//                return cell
//            }
//            .disposed(by: disposeBag)
//
//    }
    
}

// MARK: - setup
private extension MainViewController {
    func attribute() {
        navigationItem.title = "Diary"
        navigationItem.rightBarButtonItem = addDiaryButton
        updateTodayDiarys()
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
    
    func updateTodayDiarys() {
        todayDiarys = diaryManager.queryDiary(calendar.selectedDate ?? Date())
    }
}

// MARK: - @objc
private extension MainViewController {
    @objc func addDiaryButtonTapped() {
        coordinator?.showCreateViewController(date: calendar.selectedDate ?? Date())
    }
}

// MARK: - FSCalendarDataSource
extension MainViewController: FSCalendarDataSource {
    
}

// MARK: - FSCalendarDelegate
extension MainViewController: FSCalendarDelegate {
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // TODO: 완성중
//        selectedDatePublisher.onNext(date)
        updateTodayDiarys()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if diaryManager.queryDiary(date).isEmpty {
            return 0
        } else {
            return 1
        }
    }
}



// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let delete = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, success: @escaping (Bool) -> Void) in
            // 원하는 액션 추가
            guard let self = self else { return }
            self.diaryManager.deleteDiary(self.todayDiarys[indexPath.row])
            self.updateTodayDiarys()
            self.calendar.reloadData()
            success(true)
        }
        
        // 각 ContextualAction 대한 설정
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")
        
        // UISwipeActionsConfiguration에 action을 추가하여 리턴
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showDetailViewController(diary: todayDiarys[indexPath.row])
    }
    
}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todayDiarys.count == 0 {
            diaryListBackgroundView.statusLabel.isHidden = false
        } else {
            diaryListBackgroundView.statusLabel.isHidden = true
        }
        return todayDiarys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DiaryListCell.dequeueReusableCell(target: tableView, indexPath: indexPath)
        cell.setData(diary: todayDiarys[indexPath.row])
        return cell
    }
}
