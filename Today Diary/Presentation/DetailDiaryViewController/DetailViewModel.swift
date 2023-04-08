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
    let sendDiary: Driver<Diary>
    let showCreateViewController: Signal<CreateViewModel>
    
    // View -> ViewModel
    let editButtonTapped = PublishRelay<Void>()
    
    // 외부에서 전달받을 값
    let receiveDiary = ReplaySubject<Diary>.create(bufferSize: 1)
    
    // ViewController -> ParentsViewController
    let diaryDidChange = PublishSubject<Void>()
    
    init() {
        sendDiary = receiveDiary
            .asDriver(onErrorDriveWith: .empty())
        
        let createViewModel = CreateViewModel()
        createViewModel.diaryEditDone
            .bind(to: receiveDiary)
            .disposed(by: disposeBag)

        editButtonTapped
            .withLatestFrom(sendDiary) { _, diary -> Diary in
                return diary
            }
            .bind(to: createViewModel.receiveDiary)
            .disposed(by: disposeBag)
        
        
        showCreateViewController = editButtonTapped
            .map { createViewModel }
            .asSignal(onErrorSignalWith: .empty())
    }
}

