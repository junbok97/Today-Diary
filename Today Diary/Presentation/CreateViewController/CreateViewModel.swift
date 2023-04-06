//
//  CreateModel.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/05.
//

import Foundation
import RxSwift
import RxCocoa

struct CreateViewModel {
    private let disposeBag = DisposeBag()
    
    // ViewModel -> View
    let getDiary: Driver<Diary>
    let popViewController: Signal<Void>
    
    // View -> ViewModel
    let saveButtonTapped = PublishRelay<Void>()
    
    // 외부에서 전달받을 값
    let deliveryDiary = PublishSubject<Diary>()
    
    // ViewController -> ParentsViewController
    let diaryEditDone = PublishRelay<Diary>()
    init() {
        
        getDiary = deliveryDiary
            .asDriver(onErrorDriveWith: .empty())
        
        
        // TODO: Diary를 만들면 부모한테 알려줘서 queryDiary 하여 cellData 갱신
        saveButtonTapped
            .withLatestFrom(deliveryDiary) { _, diary in
                DiaryManager.shared.editDiary(diary)
                return diary
            }
            .bind(to: diaryEditDone)
            .disposed(by: disposeBag)
            
            
        popViewController = saveButtonTapped
            .asSignal(onErrorSignalWith: .empty())
    }
    
}
