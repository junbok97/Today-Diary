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
    private let selectedDateSubject = PublishSubject<Date>()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: SystemImage.plus.image, style: .done, target: self, action: nil)
        barButton.tintColor = .label
        return barButton
    }()
    
    let diaryListBackgroundView = DiaryListBackgroundView()
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.delegate = self
        calendar.dataSource = self
        // 전월이나 다음월의 일수를 표현할 것인지
        // ex) 30 31 1 2 3 or 1 2 3
        calendar.placeholderType = .none
        // 달력에 표시되는 헤더
        
        calendar.appearance.headerDateFormat = MainViewControllerContents.calendarHeaderDateFormat
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
        tableView.backgroundColor = .secondarySystemBackground
        tableView.backgroundView = diaryListBackgroundView
        DiaryListCell.register(target: tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var viewModel: MainViewModel!
    weak var coordinator: MainCoordinatorProtocol?
    
    static func create(
        _ viewModel: MainViewModel,
        _ coordinator: MainCoordinator
    ) -> MainViewController {
        let vc = MainViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadDiaryData.accept(Void())
        viewModel.reloadCalendar.accept(Void())
    }
    
    func bind() {
        rightBarButtonItem.rx.tap
            .bind(to: viewModel.didTappedRightBarButtonItem)
            .disposed(by: disposeBag)
        
        diaryListBackgroundView
            .bind(viewModel.diaryListBackgroundViewModel)
        
        // Calander에서 선택한 Date 보내기 선택되지 않았다면 오늘날짜 보내기
        selectedDateSubject
            .startWith(Date())
            .bind(to: viewModel.dateSelected)
            .disposed(by: disposeBag)
        
        diaryList.rx.itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        diaryList.rx.itemDeleted
            .bind(to: viewModel.itemDeleted)
            .disposed(by: disposeBag)
        
        viewModel.reloadCalendar
            .bind(to: self.rx.reloadCalendar)
            .disposed(by: disposeBag)
        
        viewModel.diaryListCellData
            .drive(diaryList.rx.items) { tableView, _, item in
                let cell = DiaryListCell.dequeueReusableCell(target: tableView, indexPath: nil)
                cell.setData(diary: item)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.showDetailViewController
            .emit(to: self.rx.showDetailViewController)
            .disposed(by: disposeBag)
        
        viewModel.showCreateViewController
            .emit(to: self.rx.showCreateViewController)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - setup
private extension MainViewController {
    func attribute() {
        navigationItem.title = MainViewControllerContents.navigationItemTitle
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func layout() {
        [calendar, diaryList].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: MainViewControllerContents.calendarHeight),
            
            diaryList.topAnchor.constraint(equalTo: calendar.bottomAnchor),
            diaryList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}


// MARK: - FSCalendarDelegate
extension MainViewController: FSCalendarDelegate, FSCalendarDataSource {
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDateSubject.onNext(date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return DiaryManager.shared.queryDiary(date).isEmpty ? 0 : 1
    }
}

// MARK: - Extension Reactive
extension Reactive where Base: MainViewController {
    var reloadCalendar: Binder<Void> {
        return Binder(base) { base, _ in
            base.calendar.reloadData()
        }
    }
    
    var showDetailViewController: Binder<DetailViewModel> {
        return Binder(base) { base, viewModel in
            base.coordinator?.showDetailViewController(viewModel)
        }
    }
    
    var showCreateViewController: Binder<CreateViewModel> {
        return Binder(base) { base, viewModel in
            base.coordinator?.showCreateViewController(viewModel)
        }
    }
}
