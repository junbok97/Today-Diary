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

    // View -> ViewModel
    let addDiaryButtonTapped = PublishRelay<Void>()
    let deleteDiary = PublishRelay<Void>()
    let selectDate = PublishRelay<Date>()
    
    let diaryData = PublishSubject<[Diary]>()
    

    
    init() {
        diaryListCellData = diaryData
            .asDriver(onErrorDriveWith: .empty())
        
        diaryData
            .map { !$0.isEmpty } // 비어있으면 isHidden = false 비어있지 않으면 isHidden = true
            .bind(to: diaryListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)
    }
    
    
}
