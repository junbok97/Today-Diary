//
//  DiaryListBackgroundViewModel.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import RxCocoa
import RxSwift
import UIKit

struct DiaryListBackgroundViewModel {
    
    // viewModel -> View
    let isSatusLabelHidden: Signal<Bool>
    
    // 외부에서 전달받을 값
    let shouldHideStatusLabel = PublishSubject<Bool>()
    
    init() {
        isSatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true)
    }

}
