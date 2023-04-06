//
//  DetailViewModel.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/04.
//


import UIKit
import RxSwift
import RxCocoa


struct DetailViewModel {
    
    let disposeBag = DisposeBag()
    
    // ViewModel -> View
    let getDiary: Driver<Diary>
    let showCreateViewController: Signal<CreateViewModel>
    
    // View -> ViewModel
    let editButtonTapped = PublishRelay<Void>()
    
    // 외부에서 전달받을 값
    let diaryId = PublishSubject<String>()
    
    
    
    init() {
        getDiary = diaryId
            .compactMap { DiaryManager.shared.getDiary($0) }
            .asDriver(onErrorDriveWith: .empty())
        
        getDiary
            .drive()
            .disposed(by: disposeBag)
        
        
        let createViewModel = CreateViewModel()
        editButtonTapped
            .withLatestFrom(getDiary) { _, diary -> Diary in
                return diary
            }
            .bind(to: createViewModel.deliveryDiary)
            .disposed(by: disposeBag)
        
        
        showCreateViewController = editButtonTapped
            .map { createViewModel }
            .asSignal(onErrorSignalWith: .empty())
    }
}

