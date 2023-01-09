//
//  SceneDelegate.swift
//  test_project_GTL
//
//  Created by User on 30.12.2022.
//

import UIKit

typealias WebsitesList = [[String: [String: Any]]]

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let appGroupName = "group.Artem-Golikov.test-project-GTL.batch"
        let defaults = UserDefaults(suiteName: appGroupName)
        if defaults?.object(forKey: "blackListSites") as? WebsitesList != nil {
            window?.rootViewController = ListsTabBarController()
        } else {
            window?.rootViewController = UINavigationController(rootViewController: ContentBlockerViewController())
        }
        window?.makeKeyAndVisible()
    }
}
