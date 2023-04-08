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
    let sendDiary: Driver<Diary?>
    let popViewController: Signal<Void>
    
    // View -> ViewModel
    let saveButtonTapped = PublishRelay<(title: String, contents: String)>()
    
    // 외부에서 전달받을 값
    let receiveData = ReplaySubject<(date: Date?, diary: Diary?)>.create(bufferSize: 1)
    
    
    // ViewController -> ParentsViewController
    let diaryEditDone = PublishRelay<Void>()
    
    init() {
        sendDiary = receiveData
            .map { $0.diary }
            .asDriver(onErrorDriveWith: .empty())
            
        // TODO: Diary를 만들면 부모한테 알려줘서 queryDiary 하여 cellData 갱신
        // Diary를 Save하면
        // DetailViewModel은 수정한 Diary를
        // MainViewModel은 queryDiary
        saveButtonTapped
            .withLatestFrom(receiveData, resultSelector: { saveData, data in
                if var target = data.diary {
                    target.title = saveData.title
                    target.contents = saveData.contents
                    DiaryManager.shared.editDiary(target)
                } else {
                    let target = Diary(title: saveData.title, contents: saveData.contents, date: data.date ?? Date())
                    DiaryManager.shared.addDiray(target)
                }
            })
            .bind(to: diaryEditDone)
            .disposed(by: disposeBag)
            
            
        popViewController = saveButtonTapped
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty())
    }
    
}
