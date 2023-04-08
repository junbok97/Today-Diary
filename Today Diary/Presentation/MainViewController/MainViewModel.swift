//
//  MainViewModel.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import UIKit
import RxCocoa
import RxSwift

struct MainViewModel {
    
    let disposeBag = DisposeBag()
    let diaryListBackgroundViewModel = DiaryListBackgroundViewModel()
    
    // ViewModel -> View
    let diaryListCellData: Driver<[Diary]>
    let showDetailViewController: Signal<DetailViewModel>
    let showCreateViewController: Signal<CreateViewModel>
    
    // View -> ViewModel
    let addDiaryButtonTapped = PublishRelay<Void>()
    let deleteRow = PublishRelay<IndexPath>()
    let selectDate = PublishRelay<Date>()
    let selectRow = PublishRelay<IndexPath>()
   
    
    let reloadDiaryData = PublishRelay<Void>()
    
    
    let diaryData = ReplaySubject<[Diary]>.create(bufferSize: 1)
    
    
    init() {
        reloadDiaryData
            .withLatestFrom(selectDate) { _, date in
                DiaryManager.shared.queryDiary(date)
            }
            .bind(to: diaryData)
            .disposed(by: disposeBag)
        
        diaryListCellData = diaryData
            .asDriver(onErrorDriveWith: .empty())
        
        selectDate
            .map { _ in Void() }
            .bind(to: reloadDiaryData)
            .disposed(by: disposeBag)
        
        deleteRow
            .withLatestFrom(diaryData) { indexPath, diaryList  in
                DiaryManager.shared.deleteDiary(diaryList[indexPath.row])
            }
            .bind(to: diaryData)
            .disposed(by: disposeBag)
        
        diaryData
            .map { !$0.isEmpty } // 비어있으면 isHidden = false 비어있지 않으면 isHidden = true
            .bind(to: diaryListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)

        
        // MARK: - DetailViewModel
        let detailViewModel = DetailViewModel()
        detailViewModel.diaryDidChange
            .bind(to: reloadDiaryData)
            .disposed(by: disposeBag)
            
        
        showDetailViewController = selectRow
            .map { _ -> DetailViewModel in
                return detailViewModel
            }
            .asSignal(onErrorSignalWith: .empty())
        
        selectRow
            .withLatestFrom(diaryData) { indexPath, diaryList  in
                diaryList[indexPath.row]
            }
            .bind(to: detailViewModel.receiveDiary)
            .disposed(by: disposeBag)
        
   
        // MARK: - CreateViewModel
        let createViewModel = CreateViewModel()
        createViewModel.diaryEditDone
            .bind(to: reloadDiaryData)
            .disposed(by: disposeBag)
        
        addDiaryButtonTapped
            .map { nil }
            .bind(to: createViewModel.receiveDiary)
            .disposed(by: disposeBag)
        
        showCreateViewController = addDiaryButtonTapped
            .map { createViewModel }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    
}
