//
//  DiaryListBackgroundView.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import UIKit
import RxCocoa
import RxSwift

final class DiaryListBackgroundView: UIView {
    let disposeBag = DisposeBag()
    
    lazy var statusLabel: UILabel = {
       let label = UILabel()
        label.text = "작성된 일기가 없습니다."
        label.font = .systemFont(ofSize: 25, weight: .light)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DiaryListBackgroundViewModel) {
        viewModel.isSatusLabelHidden
            .emit(to: statusLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}

private extension DiaryListBackgroundView {
    func attribute() {
        backgroundColor = .systemBackground
    }
    
    func layout() {
        addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
