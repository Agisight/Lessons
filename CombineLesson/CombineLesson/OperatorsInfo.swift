//
//  OperatorsInfo.swift
//  CombineLesson
//
//  Created by Ali on 30.01.2025.
//

import Combine
import Foundation

/*
 Операторы в Combine позволяют изменять, фильтровать и комбинировать данные.
 Давай кратко рассмотрим ключевые операторы с примерами.
 */
class OperatorsInfo {
    
    /**
     .map {} – Изменяет данные
     
     ✅ Когда использовать?
     Когда нужно преобразовать данные перед передачей.
     */
    func transformInit() {
        let publisher = [1, 2, 3].publisher

        publisher
            .map { $0 * 10 }
            .sink { print($0) } // Выведет: 10, 20, 30
    }
    
    /**
     .flatMap {} – Работает с вложенными потоками
  
     ✅ Когда использовать?
     Когда нужно обрабатывать вложенные потоки (например, сетевые запросы).
     
     */
    func flatMapInit() {
        let publisher = ["A", "B"].publisher

        publisher
            .flatMap { Just($0.lowercased()) }
            .sink { print($0) } // Выведет: "a", "b"
    }
    
    /**
     Фильтрация данных
     .filter {} – Оставляет только нужные значения
     
     ✅ Когда использовать?
     Когда нужно убрать ненужные значения.
     */
    
    func filterInit() {
        let publisher = [1, 2, 3, 4, 5, 6].publisher

        publisher
            .filter { $0 % 2 == 0 }
            .sink { print($0) } // Выведет: 2, 4, 6
    }
    
    /**
     ✅ Когда использовать?
     Когда нужно удалить повторяющиеся значения.

     */
    func removeDuplicatesInit() {
        let publisher = [1, 1, 2, 2, 3, 3].publisher

        publisher
            .removeDuplicates()
            .sink { print($0) } // Выведет: 1, 2, 3
    }
    
    /**
     .debounce() – Задержка перед отправкой
     
     ✅ Когда использовать?
     Для поиска в UITextField или уменьшения нагрузки.
     */
    func debounceInit() {
        let publisher = PassthroughSubject<String, Never>()

        publisher
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { print("Поиск: \($0)") }

        publisher.send("H")
        publisher.send("He")
        publisher.send("Hel")
        publisher.send("Hell")
        publisher.send("Hello") // Выведет только "Hello" через 0.5 сек
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            publisher.send("Hello World!")
            publisher.send("Hello World!!!!!")
        }
    }
    
    /**
     .throttle() – Ограничение частоты событий
     
     ✅ Когда использовать?
     Когда нужно ограничить частоту событий (например, нажатия кнопки).
     */
    
    func throttleInit() {
        let publisher = PassthroughSubject<String, Never>()

        publisher
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .sink { print("Вывод: \($0)") }

        publisher.send("A") // Выведет сразу
        publisher.send("B") // Пропустит
        publisher.send("C") // Выведет через 1 сек
    }
    
    /**
     .delay() – Откладывает отправку данных
     
     ✅ Когда использовать?
     Когда нужно сделать паузу перед отправкой данных.
     */
    
    func delayInit() {
        Just("Сообщение")
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { print($0) } // Выведет через 2 секунды
    }
}
