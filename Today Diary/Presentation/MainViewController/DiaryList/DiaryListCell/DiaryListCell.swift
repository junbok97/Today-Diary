//
//  DiaryListCell.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import UIKit

final class DiaryListCell: UITableViewCell, UITableViewCellRegister {
    static var cellId: String = "DiaryListCell"
    static var isFromNib: Bool = false
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(diary: Diary) {
        // TODO: label.text 설정
        titleLabel.text = diary.title
    }
}

private extension DiaryListCell {
    func attribute() {
        accessoryType = .disclosureIndicator
    }
    
    func layout() {
        contentView.addSubview(titleLabel)
        let offset: CGFloat = 10.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: offset),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -offset)
        ])
    }
}
