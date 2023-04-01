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
    
    private let disposeBag = DisposeBag()
    
    private lazy var addDiaryButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: SystemImage.plus.image, style: .done, target: self, action: #selector(addDiaryButtonTapped)) // TODO: action 추가
        barButton.tintColor = .label
        return barButton
    }()
    
    let diaryListBackgroundView = DiaryListBackgroundView()
    
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
    
    
    func bind(_ viewModel: MainViewModel) {
        diaryListBackgroundView.bind(viewModel.diaryListBackgroundViewModel)
        
        viewModel.diaryListCellData
            .drive(diaryList.rx.items) { tableView, row, item in
                let cell = DiaryListCell.dequeueReusableCell(target: tableView, indexPath: nil)
                cell.setData(diary: item)
                return cell
            }
            .disposed(by: disposeBag)
            
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

// MARK: - @objc
private extension MainViewController {
    @objc func addDiaryButtonTapped() {
        let detailViewController = DetailViewController()
        navigationController?.pushViewController(detailViewController, animated: false)
    }
}

// MARK: - FSCalendarDataSource
extension MainViewController: FSCalendarDataSource {
    
}

// MARK: - FSCalendarDelegate
extension MainViewController: FSCalendarDelegate {
    
}



// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            // 원하는 액션 추가
            // tableView.deleteRows(at: [indexPath], with: .fade)
                
            success(true)
        }
        
        // 각 ContextualAction 대한 설정
        
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")
        
        // UISwipeActionsConfiguration에 action을 추가하여 리턴
        return UISwipeActionsConfiguration(actions: [delete])
    }
}


