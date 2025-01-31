//
//  ViewController.swift
//  RxSwiftLesson
//
//  Created by Ali on 30.01.2025.
//

import RxSwift

import UIKit

class ViewController: UIViewController {

    let label: UILabel! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let observablelist = Observable.of("Видео 1", "Видео 2", "Видео 3")
        
        // Используются сложные объекты и желательно не разворачивать их (как тут), а пользоваться везде реактивным подходом дальше.
        let sub = observablelist.subscribe({ event in
            switch event {
            case .completed:
                print("Finish")
            case .next(let value):
                print(value)
                self.handle(value) // попытка использовать иперативным метод
            case .error(let error):
                print(error)
            }
        })
        sub.dispose()
    }
    
    /// Non-reactive (imperative) method
    func handle(_ value: String) {
        
    }
    
    /**
     1️⃣ Observable (Наблюдаемый) – "YouTube-канал" 🎥
     Что это?
     👉 Это источник данных, который раздаёт значения подписчикам.

     Аналогия:
     YouTube-канал 🎥 выкладывает новые видео. Вы подписываетесь на него, и вам приходят уведомления.
     
     
     2️⃣ Observer (Подписчик) – "Зритель YouTube" 👀
     Что это?
     👉 Это объект, который слушает данные от Observable.

     Аналогия:
     Вы подписались на YouTube-канал и получаете уведомления о новых видео.
     
     
     ✅ Что здесь происходит?

     Observable.of(...) — создаём поток данных (YouTube-канал).
     .subscribe {} — подписываемся и получаем все значения (уведомления).
     
     ✅ Здесь subscribe подписался на изменения и сразу получил значение.
     */
    func simple() {
        let observable = Observable.of("Видео 1", "Видео 2", "Видео 3")

        observable.subscribe { event in
            print(event)
        }
    }
    
    /**
     3️⃣ Operators (Операторы) – "Фильтры и обработка данных" 🎛
     Что это?
     👉 Операторы позволяют изменять или фильтровать поток данных.

     Аналогия:
     Вы смотрите YouTube, но хотите пропустить рекламу, ускорить видео или поменять язык.
     
     */
    
    func filterExample() {
        // Пример: .map {} (изменяем данные)
        Observable.of(1, 2, 3, 4)
            .map { $0 * 10 } // Умножаем каждое число на 10
            .subscribe { print($0) }
        
        
        // Пример: .filter {} (оставляем нужные значения)
        Observable.of(1, 2, 3, 4, 5, 6)
            .filter { $0 % 2 == 0 } // Оставляем только чётные
            .subscribe { print($0) }
    }
    
    /**
     Что это?
     👉 Subject — это и Observable, и Observer одновременно.
     👉 Можно и отправлять данные, и подписываться на них.

     Аналогия:
     Представьте WhatsApp-группу.

     Люди отправляют сообщения (send()).
     Другие читают их (subscribe()).
     
     ✅ Поздние подписчики не получают прошлые сообщения (как в чате).
     */
    func subjectInit() {
        let subject = PublishSubject<String>()

        subject.subscribe { print("Подписчик 1: \($0)") }

        subject.onNext("Привет!")
        subject.onNext("Как дела?")

        subject.subscribe { print("Подписчик 2: \($0)") }

        subject.onNext("Новое сообщение!")
    }
    
    /**
     5️⃣ DisposeBag (Мусорка) – "Отписка от канала" 🗑
     Что это?
     👉 В RxSwift подписки живут вечно, пока их не удалят.
     👉 DisposeBag автоматически очищает подписки.

     Аналогия:
     Если вы больше не хотите смотреть YouTube-канал, вы отписываетесь.
     
     ✅ Теперь подписки не будут утекать в память.
     */
    func disposeBagExample() {
        let disposeBag = DisposeBag()

        Observable.of("Привет, RxSwift!")
            .subscribe { print($0) }
            .disposed(by: disposeBag) // Отписываемся, когда объект удалится

    }
}

