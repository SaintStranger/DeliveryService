//
//  FavoritesPresenter.swift
//  DeliveryService
//
//  Created by test on 05.05.2022.
//

import Foundation
import UIKit

protocol FavortitesViewProtocol: AnyObject {
    func updateTable()
}


protocol FavortitesViewPresenterProtocol: AnyObject {
    init (view: FavortitesViewProtocol, storageManager: StorageManager, router: RouterProtocol)
    var model: [PhotoModel]? { get set }
    func gettingPhoto(urlString: String) -> UIImage?
    func deleteData(model: PhotoModel)
    func getObservers()
    func setUpTable()
    func viewPhotoChecking()
    func updateTable()
    func showDetails(photo: PhotoModel?)
}


class FavortitesTablePresenter: FavortitesViewPresenterProtocol {

    
        
    weak var view: (FavortitesViewProtocol)?
    var model: [PhotoModel]?
    var storageManager: StorageProtocol
    var router: RouterProtocol?
    
    
    required init(view: FavortitesViewProtocol, storageManager: StorageManager, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.storageManager = storageManager
        self.model = []
        viewPhotoChecking()
        getObservers()
    }
    
    func gettingPhoto(urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        let photoData = try? Data(contentsOf: url)
        let dataFailed = Data("Фото не удалось получить".utf8)
        let photo = UIImage(data: photoData ?? dataFailed)
        return photo
    }
    
    func deleteData(model: PhotoModel) {
        storageManager.deleteFromBase(photoModel: model)
    }

    func viewPhotoChecking() {
        storageManager.loadFromFirebase()
    }
    
    func getObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(setUpTable), name: NSNotification.Name(rawValue: "Load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: NSNotification.Name(rawValue: "Write"), object: nil)
    }
    
    
    @objc func setUpTable() {
        self.model = storageManager.addPhotosToTable(photos: storageManager.model)
        view?.updateTable()
    }
    
    @objc func updateTable() {
        storageManager.loadFromFirebase()
        view?.updateTable()
    }
    
    func showDetails(photo: PhotoModel?) {
        self.router?.showDetails(photo: photo)
    }

    
}






