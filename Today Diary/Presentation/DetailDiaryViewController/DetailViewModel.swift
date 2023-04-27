//
//  DetailViewModel.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/04.
//


import Foundation
import RxSwift
import RxCocoa


final class DetailViewModel {
    
    let disposeBag = DisposeBag()
    
    // ViewModel -> View
    let sendDiary: Driver<Diary>
    let showCreateViewController: Signal<CreateViewModel>
    
    // View -> ViewModel
    let editButtonTapped = PublishRelay<Void>()
    
    // 외부에서 전달받을 값
    let receiveDiary = ReplayRelay<Diary>.create(bufferSize: 1)

    
    init() {
        sendDiary = receiveDiary
            .asDriver(onErrorDriveWith: .empty())
        
        let createViewModel = CreateViewModel()
        
        createViewModel.didTappedRightBarButtonItem
            .withLatestFrom(receiveDiary) { _, diary in
                DiaryManager.shared.getDiary(diary.id)!
            }
            .bind(to: receiveDiary)
            .disposed(by: disposeBag)
        
        receiveDiary
            .bind(to: createViewModel.receiveDiary)
            .disposed(by: disposeBag)
        
        showCreateViewController = editButtonTapped
            .map { createViewModel }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    
}
