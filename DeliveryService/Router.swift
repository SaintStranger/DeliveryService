//
//  Router.swift
//  DeliveryService
//
//  Created by test on 05.05.2022.
//

import UIKit

protocol RouterMain {
    var tabBarController: MyTabBarController? { get set }
    var navController: UINavigationController? { get set }
    var controllersBuilder: ControllersBuilder? { get set }
}

protocol RouterProtocol: RouterMain {
    
    func setupTabBar()
    func showDetails(photo: PhotoModel?)
    
}

class Router: RouterProtocol {
    
    var tabBarController: MyTabBarController?
    var navController: UINavigationController?
    var controllersBuilder: ControllersBuilder?
    
    init (tabBarController: MyTabBarController, navController: UINavigationController, controllersBuilder: ControllersBuilder) {
        self.tabBarController = tabBarController
        self.navController = navController
        self.controllersBuilder = controllersBuilder
    }

    
    
    func setupTabBar() {
        if let tabBarController = tabBarController {
            
            var tabs: [UIViewController] = []
            
            if let photosCollectionVC = controllersBuilder?.createPhotoCVC(router: self) {
                let navCVC = UINavigationController(rootViewController: photosCollectionVC)
                navCVC.title = "Фотографии"
                navCVC.tabBarItem.image = UIImage(systemName: "photo.fill")
                tabs.append(navCVC)
            }
            
            if let favoritesTableVC = controllersBuilder?.createFavoritesTVC(router: self) {
                let navTVC = UINavigationController(rootViewController: favoritesTableVC)
                navTVC.title = "Избранное"
                navTVC.tabBarItem.image = UIImage(systemName: "star.fill")
                tabs.append(navTVC)
            }

            tabBarController.setViewControllers(tabs, animated: true)
            tabBarController.tabBar(tabBarController.tabBar, didSelect: tabBarController.tabBarItem)
        }
        
    }

    
    func showDetails(photo: PhotoModel?) {

        for item in tabBarController?.viewControllers ?? [] {
            if let navController = item as? UINavigationController {
                guard let detailsViewController = controllersBuilder?.createDetailsView(photo: photo, router: self) else { return }
                navController.pushViewController(detailsViewController, animated: true)
            }
        }

    }
    
}


