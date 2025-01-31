//
//  ViewController.swift
//  CombineLesson
//
//  Created by Ali on 30.01.2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.present(AppCoordinator().start(), animated: true)
    }
    
    func sendMessage() {
        view.backgroundColor = .red
    }
    
    func sendMessage2() {
        /// Big logic
        view.backgroundColor = .red
    }
}

import Combine

extension UIControl {
    func publisher(for event: UIControl.Event) -> AnyPublisher<Void, Never> {
        return UIControlPublisher(control: self, event: event).eraseToAnyPublisher()
    }
}

struct UIControlPublisher: Publisher {
    typealias Output = Void
    typealias Failure = Never

    private let control: UIControl
    private let event: UIControl.Event

    init(control: UIControl, event: UIControl.Event) {
        self.control = control
        self.event = event
    }

    func receive<S: Subscriber>(subscriber: S) where S.Input == Void, S.Failure == Never {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: event)
        subscriber.receive(subscription: subscription)
    }
}

final class UIControlSubscription<S: Subscriber>: Subscription where S.Input == Void, S.Failure == Never {
    private var subscriber: S?
    private let control: UIControl
    private let event: UIControl.Event

    init(subscriber: S, control: UIControl, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        self.event = event

        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(())
    }
}
