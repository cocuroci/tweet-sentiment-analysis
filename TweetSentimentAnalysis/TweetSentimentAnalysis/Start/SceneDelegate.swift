//
//  SceneDelegate.swift
//  TweetSentimentAnalysis
//
//  Created by André Martins on 05/02/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = UINavigationController(rootViewController: SearchFactory.make())
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

