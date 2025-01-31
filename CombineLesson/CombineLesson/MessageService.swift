//
//  MessageService.swift
//  CombineLesson
//
//  Created by Ali on 30.01.2025.
//

import Foundation
import Combine

/**
 ✅ Что здесь происходит?

 CurrentValueSubject<[String], Never> (хранит всю историю).
 Новые подписчики получают все предыдущие сообщения, а не только новые.
 sendMessage(_:) — отправляет сообщение.
 observeMessages() — позволяет подписаться на сообщения.
 */

class MessageService {
    static let shared = MessageService()
    
    let messagesSubject = CurrentValueSubject<String, Never>("")

    private init() {}

    func sendMessage(_ text: String) {
        messagesSubject.send(text)
    }
    
    func observeMessages() -> AnyPublisher<String, Never> {
        return messagesSubject.eraseToAnyPublisher()
    }
}
