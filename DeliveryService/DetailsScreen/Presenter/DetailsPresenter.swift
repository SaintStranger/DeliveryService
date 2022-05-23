//
//  DetailsPresenter.swift
//  DeliveryService
//
//  Created by test on 05.05.2022.
//

import Foundation
import UIKit

protocol DetailsViewProtocol: AnyObject {
    func setPhoto(photo: PhotoModel?)
    func setButton(title: String, tag: Int)
}

protocol DetailsPresenterProtocol: AnyObject {
    init(view: DetailsViewProtocol, router: RouterProtocol, networkService: NetworkProtocol, storageManager: StorageManager, photo: PhotoModel?)
    func gettingPhoto(urlString: String) -> UIImage?
    func setPhoto()
    func writeToBase()
    func removeFromBase()
    func checkPhoto()
    func buttonChanger()
}

class DetailsPresenter: DetailsPresenterProtocol {
    
    
    weak var view: DetailsViewProtocol?
    var storageManager: StorageProtocol
    var router: RouterProtocol?
    var photo: PhotoModel?
    
    
    required init(view: DetailsViewProtocol, router: RouterProtocol, networkService: NetworkProtocol, storageManager: StorageManager, photo: PhotoModel?) {
        self.view = view
        self.photo = photo
        self.router = router
        self.storageManager = storageManager
    }
    
    func gettingPhoto(urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        let photoData = try? Data(contentsOf: url)
        let dataFailed = Data("Фото не удалось получить".utf8)
        let photo = UIImage(data: photoData ?? dataFailed)
        return photo
    }
    
    func setPhoto() {
        self.view?.setPhoto(photo: photo)
    }
    
    func writeToBase() {
        storageManager.writeToBase(photoModel: photo)
    }
    
    func removeFromBase() {
        storageManager.deleteFromBase(photoModel: photo)
    }
    
    func checkPhoto() {

        storageManager.checkFirebase()
        
        NotificationCenter.default.addObserver(self, selector: #selector(buttonChanger), name: NSNotification.Name(rawValue: "Check"), object: nil)

    }
    

    @objc public func buttonChanger() {
        
        guard photo != nil else { return }
        
        if self.storageManager.checkExistance(photoId: photo!.id, array: storageManager.baseId) {
            view?.setButton(title: "Убрать из избранного", tag: 1)
        } else {
            view?.setButton(title: "Добавить в избранное", tag: 0)
        }

    }
    
    
}

