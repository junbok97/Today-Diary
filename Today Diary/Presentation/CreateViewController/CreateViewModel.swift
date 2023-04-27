//
//  CreateModel.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/05.
//

import Foundation
import RxSwift
import RxCocoa



final class CreateViewModel {
    private let disposeBag = DisposeBag()
    
    // ViewModel -> View
    let diaryData: Driver<Diary>
    let popViewController = PublishRelay<Void>()
    
    // View -> ViewModel
    let didTappedRightBarButtonItem = PublishRelay<Void>()
    let titleText = PublishRelay<String?>()
    let contentsText = PublishRelay<String?>()
    
    // 외부에서 전달받을 값
    let receiveDiary = ReplayRelay<Diary>.create(bufferSize: 1)
    
    init() {
        diaryData = receiveDiary
            .asDriver(onErrorDriveWith: .empty())
        
        let saveDiaryData = Observable
            .combineLatest(receiveDiary, titleText, contentsText) { (diary, title, contents) -> Diary in
                var diary = diary
                if let title = title, title != "" { diary.title = title }
                if let contents = contents, contents != CreateViewControllerContents.contentsTextViewPlaceHolder, contents != "" { diary.contents = contents }
                return diary
            }
        
        // Diary 저장 후 popViewController
        didTappedRightBarButtonItem
            .withLatestFrom(saveDiaryData) { _, diary in
                DiaryManager.shared.editDiary(diary)
            }
            .bind(to: popViewController)
            .disposed(by: disposeBag)
    }
    
}
