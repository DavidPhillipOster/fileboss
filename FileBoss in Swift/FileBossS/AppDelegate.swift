//  AppDelegate.swift
//
//  Created by david on 1/13/21.
//  Created by David Phillip Oster on 1/13/21.
//  Copyright © 2020 David Phillip Oster. All rights reserved.
// Open Source under Apache 2 license. See LICENSE in https://github.com/DavidPhillipOster/fileboss/ .

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

