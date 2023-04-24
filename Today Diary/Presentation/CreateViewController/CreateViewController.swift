//
//  CreateViewController.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateViewController: UIViewController {
    private let inset: CGFloat = 4.0
    private let offset: CGFloat = 12.0
    private let borderWidth: CGFloat = 1.0
    private let textFieldHeight: CGFloat = 65.0
    private let disposeBag = DisposeBag()

    var coordinator: CreateCoorinatorProtocol?
    private var stackViewBottomConstraint: NSLayoutConstraint!
    
    private lazy var saveButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: CreateViewControllerContents.rightBarButtonItemTitle,
            style: .plain,
            target: self,
            action: nil
        )
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = CreateViewControllerContents.titleTextFieldPlaceHolder
        textField.font = .titleFont()
        textField.addPadding()
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.contentHorizontalAlignment = .leading
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.font = .contentFont()
        textView.textColor = .secondaryLabel
        textView.text = CreateViewControllerContents.contentsTextViewPlaceHolder
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleTextField, datePicker, contentsTextView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    

    override func viewDidLoad() {
        attribute()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotifications()
    }
    
    func bind(_ viewModel: CreateViewModel) {
        saveButton.rx.tap
            .map { [weak self] in
                guard let self = self else { return ("", "") }
                return (self.titleTextField.text ?? "", self.contentsTextView.text)
            }
            .bind(to: viewModel.saveButtonTapped)
            .disposed(by: disposeBag)        

        viewModel.sendDiary
            .drive(self.rx.setupContents)
            .disposed(by: disposeBag)
        
        viewModel.popViewController
            .emit(to: self.rx.popViewController)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - setup
private extension CreateViewController {
    func attribute() {
        navigationItem.title = CreateViewControllerContents.navigationItemTitle
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func layout() {
        view.addSubview(stackView)
        
        stackViewBottomConstraint =  stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset)
        
        
        NSLayoutConstraint.activate([
            titleTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            stackViewBottomConstraint
        ])
    }
}

// MARK: -
private extension CreateViewController {
    
    func alert() {
        let alertController = UIAlertController(title: "알림", message: "제목과 내용을 입력해주세요", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
        present(alertController, animated: true)
    }
}

// MARK: - 키보드 설정
private extension CreateViewController {
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification) {
        // 키보드의 높이만큼 화면을 올려준다.
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            stackViewBottomConstraint.constant = -(offset + keyboardHeight)
            
        }
        
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification) {
        // 키보드의 높이만큼 화면을 내려준다.
        stackViewBottomConstraint.constant = -offset
    }
}

// MARK: - UITextViewDelegate
extension CreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == CreateViewControllerContents.contentsTextViewPlaceHolder {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = CreateViewControllerContents.contentsTextViewPlaceHolder
            textView.textColor = .secondaryLabel
        }
    }
}

// MARK: - UITextFieldDelegate
extension CreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension Reactive where Base: CreateViewController {
    var setupContents: Binder<Diary?> {
        return Binder(base) { base, diary in
            guard let diary = diary else { return }
            base.titleTextField.text = diary.title
            base.datePicker.date = diary.date
            base.contentsTextView.text = diary.contents
            base.contentsTextView.textColor = .label
        }
    }
    
    var popViewController: Binder<Void> {
        return Binder(base) { base, _ in
            base.coordinator?.finish()
        }
    }
}
