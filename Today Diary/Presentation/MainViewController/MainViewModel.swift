//
//  MainViewModel.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import Foundation
import RxCocoa
import RxSwift

final class MainViewModel {
    
    let disposeBag = DisposeBag()
    let diaryListBackgroundViewModel = DiaryListBackgroundViewModel()
    
    // ViewModel -> View
    let diaryListCellData: Driver<[Diary]>
    let showDetailViewController: Signal<DetailViewModel>
    let showCreateViewController: Signal<CreateViewModel>
    
    // View -> ViewModel
    let didTappedRightBarButtonItem = PublishRelay<Void>()
    let itemDeleted = PublishRelay<IndexPath>()
    let dateSelected = PublishRelay<Date>()
    let itemSelected = PublishRelay<IndexPath>()
    
    // reload해야하는 순간
    let reloadCalendar = PublishRelay<Void>()
    let reloadDiaryData = PublishRelay<Void>()
    
    let diaryData = ReplaySubject<[Diary]>.create(bufferSize: 1)
    
    init() {
        diaryListCellData = diaryData
            .asDriver(onErrorDriveWith: .empty())

        
        // reload이벤트가 들어오면 View에 새로운 diaryList
        reloadDiaryData
            .withLatestFrom(dateSelected) { _, date in
                DiaryManager.shared.queryDiary(date)
            }
            .bind(to: diaryData)
            .disposed(by: disposeBag)
        
        // item을 삭제하고 reloadDiary
        itemDeleted
            .withLatestFrom(diaryData) { indexPath, diaryList  in
                DiaryManager.shared.deleteDiary(diaryList[indexPath.row])
            }
            .bind(to: reloadDiaryData)
            .disposed(by: disposeBag)
        
        // item이 삭제되면 reloadCalnedr
        itemDeleted
            .map { _ in Void() }
            .bind(to: reloadCalendar)
            .disposed(by: disposeBag)
        
        // date가 선택되면 reloadDiary
        dateSelected
            .map { _ in Void() }
            .bind(to: reloadDiaryData)
            .disposed(by: disposeBag)
        

        // DiaryListBackgroundView 보여줄지 말지
        diaryData
            .map { !$0.isEmpty } // 비어있으면 isHidden = false 비어있지 않으면 isHidden = true
            .bind(to: diaryListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)

        
        // MARK: - DetailViewModel
        let detailViewModel = DetailViewModel()
        
        showDetailViewController = itemSelected
            .map { _ in return detailViewModel }
            .asSignal(onErrorSignalWith: .empty())
        
        itemSelected
            .withLatestFrom(diaryData) { indexPath, diaryList  in
                diaryList[indexPath.row]
            }
            .bind(to: detailViewModel.receiveDiary)
            .disposed(by: disposeBag)
        
   
        // MARK: - CreateViewModel
        let createViewModel = CreateViewModel()
        
        didTappedRightBarButtonItem
            .withLatestFrom(dateSelected) { _, date in
                Diary(
                    title: "",
                    contents: CreateViewControllerContents.contentsTextViewPlaceHolder,
                    date: date
                )
            }
            .bind(to: createViewModel.receiveDiary)
            .disposed(by: disposeBag)
        
        showCreateViewController = didTappedRightBarButtonItem
            .map { createViewModel }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    
}
