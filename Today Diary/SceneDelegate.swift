//
//  SceneDelegate.swift
//  Today Diary
//
//  Created by 이준복 on 2023/03/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var appCoordinator: MainCoordinatorProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let navi = UINavigationController()
        self.appCoordinator = MainCoordinator(navi: navi)
        self.appCoordinator?.start()
        
        self.window?.backgroundColor = .systemBackground
        self.window?.rootViewController = navi
        self.window?.makeKeyAndVisible()
    }
}
