//
//  MainTabbarController.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarController()
        setupAppearance()
    }
    
    private func setupTabbarController() {
        let homeVC = HomeViewController()
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let tunaVC = TunaViewController()
        let tunaNavController = UINavigationController(rootViewController: tunaVC)
        tunaNavController.tabBarItem = UITabBarItem(
            title: "Tuner",
            image: UIImage(systemName: "tuningfork"),
            selectedImage: UIImage(systemName: "tuningfork")
        )
        
        let learningVC = LearningViewController()
        let learningNavController = UINavigationController(rootViewController: learningVC)
        learningNavController.tabBarItem = UITabBarItem(
            title: "Learn",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        
        let profileVC = ProfileViewController()
        let profileNavController = UINavigationController(rootViewController: profileVC)
        profileNavController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [homeNavController, tunaNavController, learningNavController, profileNavController]
    }
    
    private func setupAppearance() {
        tabBar.tintColor = AppColors.mainAccentColor
        tabBar.unselectedItemTintColor = AppColors.componentsColor
        tabBar.backgroundColor = AppColors.backgroundColor
    }
}

