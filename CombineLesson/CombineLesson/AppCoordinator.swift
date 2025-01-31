//
//  AppCoordinator.swift
//  CombineLesson
//
//  Created by Ali on 30.01.2025.
//

import Foundation
import UIKit

class AppCoordinator {
    var window: UIWindow?

    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        
        let userAViewController = UserAViewController()
        userAViewController.title = "Пользователь A"
        
        let userBViewController = UserBViewController()
        userBViewController.title = "Пользователь B"
        
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: userAViewController),
            UINavigationController(rootViewController: userBViewController)
        ]

        return tabBarController
    }
}
