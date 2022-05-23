//
//  CollectionPresenter.swift
//  DeliveryService
//
//  Created by test on 02.05.2022.
//

import Foundation
import UIKit


protocol CollectionViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}


protocol CollecionViewPresenterProtocol: AnyObject {
    init (view: CollectionViewProtocol, networkService: NetworkProtocol, stringToImageConverter: StringToImageConverter, router: RouterProtocol)
    func showDetails(photo: PhotoModel)
    func viewPhotoLoading()
    func searchPhoto(keyWord: String)
    func gettingPhoto(urlString: String) -> UIImage?
    var model: [PhotoModel]? { get set }
}


class PhotoCollectionPresenter: CollecionViewPresenterProtocol {

    weak var view: (CollectionViewProtocol)?
    var model: [PhotoModel]?
    var networkService: NetworkProtocol
    var router: RouterProtocol?
    
    required init(view: CollectionViewProtocol, networkService: NetworkProtocol, stringToImageConverter: StringToImageConverter, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        viewPhotoLoading()
    }

    func viewPhotoLoading() {
        networkService.viewPhotoLoading { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self.model = photos
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func searchPhoto(keyWord: String) {
        networkService.searchPhoto(keyWord: keyWord) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self.model = photos
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    
    func gettingPhoto(urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil } 
        let photoData = try? Data(contentsOf: url)
        let dataFailed = Data("Фото не удалось получить".utf8)
        let photo = UIImage(data: photoData ?? dataFailed)
        return photo
    }
    
    func showDetails(photo: PhotoModel) {
        networkService.gettingPhotoInfo(photoId: photo.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.router?.showDetails(photo: model)
                print("HOHOHO")
            case .failure(let error):
                print(error)
            }
        }
    }

}
