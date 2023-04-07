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
    let saveButtonTapped = PublishRelay<(title: String, contents: String)>()
    
    // 외부에서 전달받을 값
    let deliveryDiary = PublishSubject<Diary>()
    
    // ViewController -> ParentsViewController
    let diaryEditDone = PublishRelay<Diary>()
    
    init() {
        getDiary = deliveryDiary
            .asDriver(onErrorDriveWith: .empty())
            
        getDiary
            .drive()
            .disposed(by: disposeBag)
//
        // TODO: Diary를 만들면 부모한테 알려줘서 queryDiary 하여 cellData 갱신
        // Diary를 Save하면
        // DetailViewModel은 수정한 Diary를
        // MainViewModel은 queryDiary
        saveButtonTapped
            .withLatestFrom(deliveryDiary, resultSelector: { saveData, diary -> Diary in
                var target = diary
                target.title = saveData.title
                target.contents = saveData.contents
                DiaryManager.shared.editDiary(target)
                return target
            })
            .bind(to: diaryEditDone)
            .disposed(by: disposeBag)
            
            
        popViewController = saveButtonTapped
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty())
    }
    
}
