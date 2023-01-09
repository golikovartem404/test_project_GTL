//
//  ListsTabBar.swift
//  test_project_GTL
//
//  Created by User on 05.01.2023.
//

import UIKit

class ListsTabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureTabBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .red
        tabBar.barTintColor = .black

        let mainMenuController = UINavigationController(rootViewController: BlackListViewController())
        let infoController = UINavigationController(rootViewController: WhiteListViewController())
        let contentBlockerController = UINavigationController(rootViewController: ContentBlockerViewController())
        let chartsViewController = UINavigationController(rootViewController: ChartsViewController())
        let videoController = UINavigationController(rootViewController: AdBlockViewController())

        mainMenuController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house")
        )

        infoController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house")
        )

        contentBlockerController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house")
        )

        chartsViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house")
        )

        videoController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house")
        )

        let viewControllers = [
            mainMenuController,
            infoController,
            contentBlockerController,
            chartsViewController,
            videoController
        ]
        setViewControllers(viewControllers, animated: true)
    }


}
