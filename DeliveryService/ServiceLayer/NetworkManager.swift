//
//  NetworkManager.swift
//  DeliveryService
//
//  Created by test on 02.05.2022.
//

import Foundation
import Alamofire
import UIKit

protocol NetworkProtocol {
    func viewPhotoLoading(complition: @escaping (Result<[PhotoModel], AFError>) -> Void)
    func searchPhoto(keyWord: String, complition: @escaping (Result<[PhotoModel], AFError>) -> Void)
    func gettingPhotoInfo(photoId: String, complition: @escaping (Result<PhotoModel, AFError>) -> Void)
}


class NetworkManager: NetworkProtocol {
    
    func viewPhotoLoading(complition: @escaping (Result<[PhotoModel], AFError>) -> Void) {

        let baseURL = "https://api.unsplash.com/photos/"
        let theKey = "M2P66t2k5lbd1JkmcDTVMykhD9JPfoGBJ-emMrTqozQ"
        let parameters = [
            "client_id": theKey,
            "per_page": "30" //Пробовал большее количество, но Unsplash больше 30 не хотет отдавать
        ]

        AF.request(baseURL, method: .get, parameters: parameters).validate().responseData { response in
            guard let data = response.value else { return }
                do {
                    let photos = try JSONDecoder().decode([PhotoModel].self, from: data)
                    complition(.success(photos))
                } catch {
                    complition(.failure(AFError.createURLRequestFailed(error: error)))
                }
        }

    }
    

    func searchPhoto(keyWord: String, complition: @escaping (Result<[PhotoModel], AFError>) -> Void) {

        let baseURL = "https://api.unsplash.com/search/photos"
        let theKey = "M2P66t2k5lbd1JkmcDTVMykhD9JPfoGBJ-emMrTqozQ"
        let parameters = [
            "query": keyWord,
            "client_id": theKey,
            "per_page": "30"
        ]

        AF.request(baseURL, method: .get, parameters: parameters).validate().responseData { response in
            guard let data = response.value else { return }
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    complition(.success(searchResult.results ?? []))
                } catch {
                    complition(.failure(AFError.createURLRequestFailed(error: error)))
                }
        }

    }

    
    
    
    // MARK: Запрос на получение локации
    func gettingPhotoInfo(photoId: String, complition: @escaping (Result<PhotoModel, AFError>) -> Void) {

        let theKey = "M2P66t2k5lbd1JkmcDTVMykhD9JPfoGBJ-emMrTqozQ"
        
        var baseURL = URLComponents()
        baseURL.scheme = "https"
        baseURL.host = "api.unsplash.com"
        baseURL.path = "/photos/" + "\(photoId)"
        baseURL.queryItems = [ URLQueryItem(name: "client_id", value: theKey) ]
        
        AF.request(baseURL, method: .get, parameters: nil).validate().responseData { response in
            guard let data = response.value else { return }
                do {
                    let photoInfo = try JSONDecoder().decode(PhotoModel.self, from: data)
                    complition(.success(photoInfo))
                } catch {
                    complition(.failure(AFError.createURLRequestFailed(error: error)))
                }
        }


    }
    
    
}











