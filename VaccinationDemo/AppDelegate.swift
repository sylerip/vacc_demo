//
//  AppDelegate.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/6.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

private(set) var KeyWindow: UIWindow?

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        self.window = UIWindow.init(frame: UIScreen.main.bounds)
//
        KeyWindow = window
////
//        let nav = UINavigationController.init(rootViewController: ViewController())
//        self.window!.rootViewController = nav
//        self.window!.makeKeyAndVisible()
//
//        let item1 = UITabBarItem()
//        item1.title = ""
//        if #available(iOS 13.0, *) {
//            item1.image = UIImage(systemName: "shield.fill")
//        } else {
//            // Fallback on earlier versions
//            item1.title = "Record"
//        }
//        let mainVC = ViewController()
//        mainVC.tabBarItem = item1
//        let item2 = UITabBarItem()
//        item2.title = ""
//        if #available(iOS 13.0, *) {
//            item2.image = UIImage(systemName: "magnifyingglass")
//        } else {
//            // Fallback on earlier versions
//            item2.title = "Scan"
//        }
//        let searchVC = SearchViewController()
//        searchVC.tabBarItem = item2
//        let tabBarController = UITabBarController()
//        tabBarController.viewControllers = [mainVC, searchVC]
//        tabBarController.selectedViewController = mainVC
//        tabBarController.selectedIndex = 0
//        let nav = UINavigationController.init(rootViewController: ViewController())
//        self.window?.rootViewController = tabBarController
//
        return true
    }
}

