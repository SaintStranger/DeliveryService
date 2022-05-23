//
//  ModuleBuilder.swift
//  DeliveryService
//
//  Created by test on 02.05.2022.
//

import UIKit

protocol MainBuilder {

    func createPhotoCVC(router: RouterProtocol) -> UIViewController
    func createFavoritesTVC(router: RouterProtocol) -> UIViewController
    func createDetailsView(photo: PhotoModel?, router: RouterProtocol) -> UIViewController
}


class ControllersBuilder: MainBuilder  {
    

    func createPhotoCVC(router: RouterProtocol) -> UIViewController {
        let view = PhotosCollectionVC(collectionViewLayout: PhotoCollectionLayout())
        let stringToImageConverter = StringToImageConverter()
        let presenter = PhotoCollectionPresenter(view: view, networkService: NetworkManager(), stringToImageConverter: stringToImageConverter, router: router)
        view.presenter = presenter
        return view
    }
    
    func createFavoritesTVC(router: RouterProtocol) -> UIViewController {
        let view = FavoritesTableVC()
        let presenter = FavortitesTablePresenter(view: view, storageManager: StorageManager(), router: router)
        view.presenter = presenter
        return view
    }
    
    func createDetailsView(photo: PhotoModel?, router: RouterProtocol) -> UIViewController {
        let view = DetailsViewController()
        let presenter = DetailsPresenter(view: view, router: router, networkService: NetworkManager(), storageManager: StorageManager(), photo: photo)
        view.presenter = presenter
        return view
    }
    
}


// MARK: Не самое красиыое решение, но через протоколы сделать не получилось, и уже не хотел тратить больше времени
class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        self.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        for item in self.viewControllers ?? [] {
            if let navController = item as? UINavigationController {
                navController.popToRootViewController(animated: false)
            }
        }
        
    }
}
