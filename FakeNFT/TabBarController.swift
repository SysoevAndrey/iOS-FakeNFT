//
//  TabBarController.swift
//  FakeNFT
//
//  Created by Andrey Sysoev on 17.07.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.tintColor = .blue
        tabBar.unselectedItemTintColor = .black
        
        let profileViewModel = ProfileViewModel(networkClient: nil)
        let profileViewController = UINavigationController(
            rootViewController: ProfileViewController(viewModel: profileViewModel)
        )
        
        let catalogueVM = CollectionListViewModel(provider: CatalogueDataProvider())
        let catalogueViewController = UINavigationController(
            rootViewController: CollectionListViewController()
        )
        
        let cartViewModel = CartViewModel()
        let cartViewController = UINavigationController(
            rootViewController: CartViewController(viewModel: cartViewModel)
        )
        
        let statisticsViewController = UINavigationController(
            rootViewController: UIViewController()
        )
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.crop.circle.fill"),
            selectedImage: nil
        )
        
        catalogueViewController.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(systemName: "square.stack.fill"),
            selectedImage: nil
        )
        
        cartViewController.tabBarItem = UITabBarItem(
            title: "Корзина",
            image: UIImage.Icons.cartNoActive,
            selectedImage: nil
        )
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "flag.2.crossed.fill"),
            selectedImage: nil
        )

        let controllers = [
            profileViewController,
            catalogueViewController,
            cartViewController,
            statisticsViewController
        ]
        
        viewControllers = controllers
    }
}
