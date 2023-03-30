//
//  SceneDelegate.swift
//  Today Diary
//
//  Created by 이준복 on 2023/03/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let rootViewController = MainViewController()
        let naviVC = UINavigationController(rootViewController: rootViewController)
        
        self.window?.backgroundColor = .systemBackground
        self.window?.rootViewController = naviVC
        self.window?.makeKeyAndVisible()
        
    }

   

}

