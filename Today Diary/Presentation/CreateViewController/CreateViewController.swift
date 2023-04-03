//
//  CreateViewController.swift
//  Today Diary
//
//  Created by 이준복 on 2023/04/01.
//

import UIKit

final class CreateViewController: UIViewController {
    

    let contentPlaceHolder = "Pleas Insert Content ..."
    let inset: CGFloat = 4.0
    let offset: CGFloat = 12.0
    let borderWidth: CGFloat = 1.0
    let textFieldHeight: CGFloat = 65.0
    let diaryManager = DiaryManager.shared
    
    let date: Date
    var diary: Diary?
    let isHasDiary: Bool
    
    var coordinator: CreateCoorinator?
    var stackViewBottomConstraint: NSLayoutConstraint!
    
    private lazy var doneButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(doneButtonTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.font = .titleFont()
        textField.layer.borderWidth = borderWidth
        textField.layer.borderColor = UIColor.label.cgColor
        textField.addPadding()
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .contentFont()
        textView.textColor = .secondaryLabel
        textView.text = contentPlaceHolder
        textView.delegate = self
        textView.layer.borderWidth = borderWidth
        textView.layer.borderColor = UIColor.label.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleTextField, contentTextView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(date: Date = Date(), _ diary: Diary?) {
        self.date = date
        self.diary = diary
        if diary == nil {
            self.isHasDiary = false
        } else {
            self.isHasDiary = true
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.finish()
    }
    
    deinit {
        print("createVC deinit")
    }
    
}

// MARK: - setup
private extension CreateViewController {
    func attribute() {
        navigationItem.title = "Write Diary"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = doneButton
        
        if let diary = diary {
            titleTextField.text = diary.title
            contentTextView.text = diary.content
            contentTextView.textColor = .label
        }
    }
    
    func layout() {
        view.addSubview(stackView)
        
        stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset)
        
        
        NSLayoutConstraint.activate([
            titleTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            stackViewBottomConstraint
        ])
    }
}

// MARK: - @objc
private extension CreateViewController {
    // 저장
    @objc func doneButtonTapped() {
        let title = titleTextField.text ?? ""
        let content = contentTextView.text ?? contentPlaceHolder
        if title == "" || content == contentPlaceHolder  {
            alert()
        } else {
            if isHasDiary {
                diary!.title = title
                diary!.content = content
                diaryManager.editDiary(diary!)
            } else {
                let newDiary = Diary(title: title, content: content, date: date)
                diaryManager.addDiray(newDiary)
            }
            coordinator?.saveFinish()
        }
    }
    
    func alert() {
        let alertController = UIAlertController(title: "알림", message: "제목과 내용을 입력해주세요", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
        present(alertController, animated: true)
    }
}

// MARK: - 키보드 설정
private extension CreateViewController {
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 올려준다.
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            stackViewBottomConstraint.constant = -(offset + keyboardHeight)
            
        }
        
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        stackViewBottomConstraint.constant = -offset
    }
}

// MARK: - UITextViewDelegate
extension CreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == contentPlaceHolder {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = contentPlaceHolder
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
