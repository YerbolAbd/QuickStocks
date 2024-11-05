//
//  MainTabBarController.swift
//  QuickStocks
//
//  Created by Ербол on 04.11.2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .white
        tabBar.barTintColor = UIColor(white: 0.1, alpha: 1.0)
        tabBar.isTranslucent = false
        
        
        let separator = UIView()
        separator.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let stocksViewController = StocksViewController()
        stocksViewController.title = "Акции"
        let stocksNavController = UINavigationController(rootViewController: stocksViewController)
        
        let overviewViewController = OverviewViewController()
        overviewViewController.view.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        overviewViewController.title = "Обзор"
        
        let portfolioViewController = FavoritesViewController()
        portfolioViewController.view.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        portfolioViewController.title = "Избранное"
        
        
        stocksNavController.tabBarItem = UITabBarItem(title: "Акции", image: UIImage(systemName: "chart.line.uptrend.xyaxis"), tag: 0)
        overviewViewController.tabBarItem = UITabBarItem(title: "Обзор", image: UIImage(systemName: "newspaper"), tag: 1)
        portfolioViewController.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "star"), tag: 2)
        
        
        viewControllers = [stocksNavController, overviewViewController, portfolioViewController]
        
        tabBar.tintColor = .white
        tabBar.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        tabBar.barTintColor = UIColor(white: 0.1, alpha: 1.0)
        tabBar.isTranslucent = false
    }
}

