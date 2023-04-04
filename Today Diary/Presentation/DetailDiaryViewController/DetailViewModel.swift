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
    let diary: Driver<Diary>
    
    // View -> ViewModel
    let editButtonTapped = PublishRelay<Void>()
    
    // 외부에서 전달받을 값
    let diaryId = PublishSubject<String>()
    
    
    
    init() {
        diary = diaryId
            .compactMap { DiaryManager.shared.getDiary($0) }
            .asDriver(onErrorDriveWith: .empty())
        
        diary
            .drive()
            .disposed(by: disposeBag)
        
        
        
        editButtonTapped
            .subscribe(onNext: {print("Tap")})
            .disposed(by: disposeBag)
    }
    
    
}

