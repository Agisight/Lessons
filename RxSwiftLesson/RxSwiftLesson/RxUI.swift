//
//  Rx_UI.swift
//  RxSwiftLesson
//
//  Created by Ali on 30.01.2025.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

/*
 RxSwift избавляет от кучи делегатов, таймеров и коллбэков.

 Observable — поток данных (YouTube-канал 🎥).
 Observer — подписчик (Зритель YouTube 👀).
 Operators — изменяют данные (Фильтр на YouTube 🎛).
 Subjects — работают как WhatsApp-группа 💬.
 DisposeBag — предотвращает утечки памяти (Отписка от канала 🗑).
 RxSwift упрощает асинхронный код и делает его более читаемым. 🚀
 */

class RxController: UIViewController {
    private let textField = UITextField() // TODO: make local lazy elements
    private let button = UIButton() // TODO: make local lazy elements
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.frame = CGRect(x: 20, y: 100, width: 300, height: 40)
        textField.borderStyle = .roundedRect
        view.addSubview(textField) // TODO: place with constraints
        view.addSubview(button) // TODO: place with constraints

        /*
         1️⃣ UITextField + RxSwift (поиск с debounce)
         Добавляем debounce, чтобы не отправлять данные слишком часто.
         ✅ Текст в поле ввода обрабатывается только через 0.5 сек после последнего ввода.
         */
        textField.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { text in
                print("Поиск: \(text)") // TODO: send a request to DB or server
            })
            .disposed(by: disposeBag)
        
        testButtonSubscribe()
    }
    
    
    /**
     ✅ Не нужно addTarget(_:action:for:)!
     */
    func testButtonSubscribe() {
        button.rx.tap
            .subscribe(onNext: {
                print("Кнопка нажата!")
            })
            .disposed(by: disposeBag)
    }
}
