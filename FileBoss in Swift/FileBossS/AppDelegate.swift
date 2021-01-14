//
//  AppDelegate.swift
//  FileBossS
//
//  Created by david on 1/13/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    if let window = window {
      window.rootViewController = UINavigationController(rootViewController: ViewController())
      window.makeKeyAndVisible()
    }
    return true
  }

}

