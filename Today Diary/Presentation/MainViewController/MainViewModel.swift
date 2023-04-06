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
    let deleteDiary = PublishRelay<IndexPath>()
    let selectDate = PublishRelay<Date>()
    let selectRow = PublishRelay<IndexPath>()
    
    let diaryData = PublishSubject<[Diary]>()
    
    
    
    init() {
        // TODO: Diary를 만들면 부모한테 알려줘서 queryDiary 하여 cellData 갱신
        
        
        
        selectDate
            .map { DiaryManager.shared.queryDiary($0) }
            .bind(to: diaryData)
            .disposed(by: disposeBag)
        
        diaryData
            .map { !$0.isEmpty } // 비어있으면 isHidden = false 비어있지 않으면 isHidden = true
            .bind(to: diaryListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)
        
        diaryListCellData = diaryData
            .asDriver(onErrorDriveWith: .empty())

        diaryListCellData
            .drive()
            .disposed(by: disposeBag)

        
        let detailViewModel = DetailViewModel()
        
        showDetailViewController = selectRow
            .map { _ -> DetailViewModel in
                return detailViewModel
            }
            .asSignal(onErrorSignalWith: .empty())
        
        selectRow
            .withLatestFrom(diaryData) { indexPath, diaryList  in
                diaryList[indexPath.row].id
            }
            .bind(to: detailViewModel.diaryId)
            .disposed(by: disposeBag)
        
        
        let createViewModel = CreateViewModel()
        
        addDiaryButtonTapped
            .withLatestFrom(selectDate) { _, selectDate -> Diary in
                return Diary(title: "", contents: "", date: selectDate)
            }
            .bind(to: createViewModel.deliveryDiary)
            .disposed(by: disposeBag)
        
        showCreateViewController = addDiaryButtonTapped
            .map { createViewModel }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    
}
