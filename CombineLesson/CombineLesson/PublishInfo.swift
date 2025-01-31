//
//  PublishInfo.swift
//  CombineLesson
//
//  Created by Ali on 30.01.2025.
//

import Combine
import Foundation

// В Combine есть разные способы создать Publisher (издателя) в зависимости от задачи. Давай разберём основные способы с примерами.

class PublishInfo {
    /// 🔹 1. Just – Отправка одного значения
    /// Если тебе нужно отправить одно значение и завершить поток, используй Just.
    
    /// ✅ Когда использовать?
    /// Когда нужно передать одно значение и завершить поток.
    func justInit() {
        let publisher = Just("Привет, Combine!")

        let subs = publisher.sink { value in
            print(value) // "Привет, Combine!"
        }
    }
    
    /**
     🔹 2. Future – Асинхронная операция
     Если тебе нужно выполнить асинхронный код (например, загрузка данных), используй Future.
     
     ✅ Когда использовать?
     Когда ты работаешь с асинхронными задачами (например, API-запрос).
     */
    func futureInit() {
        let futurePublisher = Future<String, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                promise(.success(""))
            }
        }

        _ = futurePublisher
            .sink { print($0) } // Выведет через 2 сек: "Данные загружены!"
    }
    
    /**
     🔹 3. Deferred – Отложенный запуск
     Deferred позволяет создать Publisher, который создаётся только при подписке.
     
     ✅ Когда использовать?
     Когда хочешь отложить создание данных до момента подписки.
     */
    func defferedInit() {
        let deferredPublisher = Deferred {
            Just("Этот текст появился при подписке!")
        }

        _ = deferredPublisher
            .sink { print($0) } // "Этот текст появился при подписке!"
    }
    
    /**
     🔹 4. Timer – Таймер (интервальный Publisher)
     Если тебе нужно создавать поток с временными интервалами, используй Timer.publish.
     
     ✅ Когда использовать?
     Когда нужно создавать периодические события (например, обновлять данные каждую секунду).
     */
    
    func timerInit() {
        let timerPublisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect() // Автозапуск таймера

        let cancellable = timerPublisher
            .sink { time in
                print("Текущее время: \(time)")
            }

    }
    
    /**
     🔹 5. PassthroughSubject – Ручная отправка данных
     Если тебе нужно создавать события вручную (например, нажали кнопку), используй PassthroughSubject.
     
     ✅ Когда использовать?
     Когда нужно отправлять данные вручную (например, по нажатию кнопки).
     */
    func passthroughInit() {
        let subject = PassthroughSubject<Int, Never>()

        let subscription = subject.sink { value in
            print("Получено: \(value)")
        }

        subject.send(1) // "Получено: Сообщение 1"
        subject.send(2) // "Получено: Сообщение 2"
    }
    
    /**
     🔹 6. CurrentValueSubject – Хранение текущего состояния
     Если тебе нужно хранить последнее значение и отправлять его новым подписчикам, используй CurrentValueSubject.
     
     ✅ Когда использовать?
     Когда хочешь хранить текущее значение и делиться им с новыми подписчиками.
     */
    
    func currentValue() {
        let currentValueSubject = CurrentValueSubject<Int, Never>(0)

        let subscription1 = currentValueSubject.sink { value in
            print("Подписчик 1: \(value)")
        }

        currentValueSubject.send(10) // "Подписчик 1: 10"
        currentValueSubject.send(20) // "Подписчик 1: 20"

        let subscription2 = currentValueSubject.sink { value in
            print("Подписчик 2: \(value)")
        }

        // "Подписчик 2: 20" (новый подписчик сразу получает последнее значение)
    }
    
    /**
     🔹 7. URLSession.DataTaskPublisher – Запрос в сеть
     Если тебе нужно получить данные из сети, Combine поддерживает URLSession.
     
     ✅ Когда использовать?
     Когда нужно работать с сетью в реактивном стиле.
     */
    
    func urlInit() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!

        let subscription = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Todo.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { print($0) })

        struct Todo: Codable {
            let id: Int
            let title: String
        }

    }
}
