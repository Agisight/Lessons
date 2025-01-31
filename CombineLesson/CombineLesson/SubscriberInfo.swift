//
//  SubscriberInfo.swift
//  CombineLesson
//
//  Created by Ali on 30.01.2025.
//

import Combine
import UIKit

/*
 Что это?
 👉 Объект, который подписывается на издателя и получает данные.

 Аналогия:
 Вы включили радио и начали слушать. Теперь вы получаете музыку и новости от станции.
 
 */

class SubscriberInfo {
    private let publisher = Just("Привет, Combine!")
    /**
     1️⃣ sink – Самый удобный способ подписки

     Just("Привет, Combine!") — создаёт поток с одним значением.
     .sink {} — подписывается на этот поток и получает данные.
     
     ✅ Когда использовать?
     Когда нужно просто обработать данные потока.
     */
    func initSink() {
        let subscription = publisher.sink { value in
            print("Получено: \(value)") // "Привет, Combine!"
        }
    }
    
    /**
     2️⃣ assign – Привязка данных к свойству
     Если у вас есть @Published или обычное свойство, можно привязать данные к нему.
     
     ✅ Когда использовать?
     Когда нужно обновлять переменные автоматически.
     */
    
    func assignInit() {
        class ViewModel {
            @Published var text: String = "Начальный текст"
        }

        let viewModel = ViewModel()
        let publisher = Just("Обновленный текст")

        let subscription = publisher
            .assign(to: \.text, on: viewModel)

        print(viewModel.text) // "Обновленный текст"
    }
    
    /**
     3️⃣ receiveSubscriber – Полный контроль
     Если нужен полный контроль, можно создать подписчика вручную.
     
     ✅ Когда использовать?
     Когда нужен полный контроль над подпиской (например, можно запрашивать данные частями).
     */
    
    func receiveSubscriberInit() {
        let publisher = [1, 2, 3, 4, 5].publisher

        final class CustomSubscriber: Subscriber {
            typealias Input = Int
            typealias Failure = Never

            func receive(subscription: Subscription) {
                print("Подписка началась")
                subscription.request(.unlimited) // Запрашиваем все данные
            }

            func receive(_ input: Int) -> Subscribers.Demand {
                print("Получено: \(input)")
                return .unlimited
            }

            func receive(completion: Subscribers.Completion<Never>) {
                print("Завершено")
            }
        }

        let subscriber = CustomSubscriber()
        publisher.subscribe(subscriber)
    }
    
    /**
     4️⃣ store(in:) – Упрощённое управление подписками
     Чтобы подписки не утекали в память, их нужно хранить. Это можно сделать с Set<AnyCancellable>().
     
     ✅ Когда использовать?
     Всегда, когда создаёшь подписки в UIViewController или ViewModel, чтобы избежать утечек памяти.
     */
    func storeInit() {
        class ViewModel {
            @Published var text: String = "Начальный текст"
            private var cancellables = Set<AnyCancellable>()

            func updateText() {
                Just("Новое значение")
                    .assign(to: \.text, on: self)
                    .store(in: &cancellables) // Подписка автоматически удалится
            }
        }

        let viewModel = ViewModel()
        viewModel.updateText()
        print(viewModel.text) // "Новое значение"
    }
    
    /**
     5️⃣ debounce + sink – Пример с UITextField
     
     ✅ Когда использовать?
     Когда нужно обрабатывать текстовые поля и ввод пользователя.
     */
    func debounceSinkMethod() {
        class ViewController: UIViewController {
            private let textField = UITextField()
            private var cancellables = Set<AnyCancellable>()

            override func viewDidLoad() {
                super.viewDidLoad()
                
                textField.frame = CGRect(x: 20, y: 100, width: 300, height: 40)
                textField.borderStyle = .roundedRect
                view.addSubview(textField)

                textField.publisher(for: \.text)
                    .compactMap { $0 }
                    .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
                    .sink { text in
                        print("Поиск: \(text)")
                    }
                    .store(in: &cancellables)
            }
        }
    }
}
