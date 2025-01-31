//
//  UserBViewController.swift
//  CombineLesson
//
//  Created by Ali on 30.01.2025.
//

import UIKit
import Combine

class UserBViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите сообщение..."
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white.withAlphaComponent(0.05)
        tf.textColor = .systemGreen
        return tf
    }()
    
    private let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Отправить", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        return btn
    }()
    
    private let chatTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = .black
        tv.textColor = .green
        tv.font = UIFont.systemFont(ofSize: 13)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = .black
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

    private func setupBindings() {
        // Отправка сообщений
        sendButton
            .publisher(for: .touchUpInside)
            .delay(for: 5, scheduler: RunLoop.current)
            .map { [weak self] in self?.textField.text ?? "" }
            .sink { text in
                self.textField.text = ""
                guard !text.isEmpty else { return }
                MessageService.shared.sendMessage("B: \(text)")
            }
            .store(in: &cancellables)

        // Получение всех сообщений
        MessageService.shared.observeMessages()
            .sink { [weak self] message in
                self?.chatTextView.text = message // .joined(separator: "\n")
            }
            .store(in: &cancellables)
    }
}
