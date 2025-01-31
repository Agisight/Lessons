//
//  UserAViewController.swift
//  CombineLesson
//
//  Created by Ali on 30.01.2025.
//

import UIKit
import Combine

class UserAViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите сообщение..."
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Отправить", for: .normal)
        return btn
    }()
    
    private let chatTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = .white
        let stack = UIStackView(arrangedSubviews: [chatTextView, textField, sendButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 300),
            chatTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    var messages: [String] = [""]
    
    private func setupBindings() {
        // Отправка сообщений
        sendButton
            .publisher(for: .touchUpInside)
            .map { [weak self] in self?.textField.text ?? "" }
            .sink { text in
                guard !text.isEmpty else { return }
                MessageService.shared.sendMessage("A: \(text)")
            }
            .store(in: &cancellables)

        // Получение всех сообщений
        MessageService.shared.observeMessages()
            .sink { [weak self] message in
                self?.chatTextView.text = (self?.chatTextView.text ?? "") + message + "\n"
            }
            .store(in: &cancellables)
    }
}

