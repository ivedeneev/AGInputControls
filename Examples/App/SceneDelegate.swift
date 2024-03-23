//
//  SceneDelegate.swift
//  Examples
//
//  Created by Igor Vedeneev on 6/24/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = scene.windows.first
        window?.rootViewController = UINavigationController(
            rootViewController: MenuViewController(style: .insetGrouped)
        )
        window?.makeKeyAndVisible()
    }
}

