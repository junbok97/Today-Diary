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
    let showDetailDiary: Driver<DetailViewModel>
    
    // View -> ViewModel
    let addDiaryButtonTapped = PublishRelay<Date>()
    let deleteDiary = PublishRelay<IndexPath>()
    let selectDate = PublishRelay<Date>()
    let selectRow = PublishRelay<IndexPath>()
    
    let diaryData = PublishSubject<[Diary]>()
    
    
    
    init() {
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
        
        showDetailDiary = selectRow
            .map { _ -> DetailViewModel in
                return detailViewModel
            }
            .asDriver(onErrorDriveWith: .empty())
        
        selectRow
            .withLatestFrom(diaryData) { indexPath, diaryList  in
                diaryList[indexPath.row].id
            }
            .bind(to: detailViewModel.diaryId)
            .disposed(by: disposeBag)
    }
    
    
}
