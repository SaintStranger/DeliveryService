//
//  StorageManager.swift
//  DeliveryService
//
//  Created by test on 02.05.2022.
//

import Foundation
import FirebaseDatabase

protocol StorageProtocol {
    var model: [PhotoModel] { get set }
    var baseId: [String] { get set }
    func loadFromFirebase2()
    func loadFromFirebase()
    func addPhotosToTable(photos: [PhotoModel]) -> [PhotoModel]
    func checkFirebase()
    func checkExistance(photoId: String, array: [String]) -> Bool
    func writeToBase(photoModel: PhotoModel?)
    func deleteFromBase(photoModel: PhotoModel?)
}



class StorageManager: StorageProtocol {
    
    var favorites: FavortitesViewProtocol!
    
    let remoteDatabase = Database.database(url: "https://deliveryservice-46e51-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    var model: [PhotoModel] = []
    
    func loadFromFirebase2() {
    
        remoteDatabase.getData { error, snapshot in
    
            if snapshot != nil {
    
                self.model = []
    
                for child in snapshot!.children {
    
                    if let snapshot = child as? DataSnapshot {
    
                        let value = snapshot.value as? [String: Any]
                        let id = value?["id"] as? String ?? ""
                        let date = value?["date"] as? String ?? ""
                        let user = value?["user"] as? [String: Any]
                        let userName = user?["name"] as? String ?? ""
                        let likes = value?["likes"] as? Int ?? 0
                        let photos = value?["photos"] as? [String: Any]
                        let photoRegular = photos?["bigPhoto"] as? String ?? ""
                        let photoSmall = photos?["smallPhoto"] as? String ?? ""
                        let location = value?["location"] as? [String: Any]
                        let locationTitle = location?["location_title"] as? String
                        let locationName = location?["location_name"] as? String
                        let locationCountry = location?["location_country"] as? String
                        let complexModel = PhotoModel(id: id, date: date, photos: Urls(regular: photoRegular, small: photoSmall), likes: likes, user: User.init(name: userName), location: Location(title: locationTitle, name: locationName, country: locationCountry))
    
                        self.model.append(complexModel)
    
                    }
    
                }
    
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Load"), object: nil)
    
            } else {
                print(error?.localizedDescription as Any)
            }
    
    
        }
    }
    
    
    
    func loadFromFirebase() {
    
        remoteDatabase.observe(.value) { snapshot in
    
            self.model = []
    
            for child in snapshot.children {
    
                if let snapshot = child as? DataSnapshot {
    
                    let value = snapshot.value as? [String: Any]
                    let id = value?["id"] as? String ?? ""
                    let date = value?["date"] as? String ?? ""
                    let user = value?["user"] as? [String: Any]
                    let userName = user?["name"] as? String ?? ""
                    let likes = value?["likes"] as? Int ?? 0
                    let photos = value?["photos"] as? [String: Any]
                    let photoRegular = photos?["bigPhoto"] as? String ?? ""
                    let photoSmall = photos?["smallPhoto"] as? String ?? ""
                    let location = value?["location"] as? [String: Any]
                    let locationTitle = location?["location_title"] as? String
                    let locationName = location?["location_name"] as? String
                    let locationCountry = location?["location_country"] as? String
                    let complexModel = PhotoModel(id: id, date: date, photos: Urls(regular: photoRegular, small: photoSmall), likes: likes, user: User.init(name: userName), location: Location(title: locationTitle, name: locationName, country: locationCountry))
    
                    self.model.append(complexModel)
    
                }
    
            }
    
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Load"), object: nil)
        }
    }
    
    
    func addPhotosToTable(photos: [PhotoModel]) -> [PhotoModel] {
        guard photos.count > 0 else { return [] }
        let sortedPhotos = photos.sorted { $0.user.name.lowercased() < $1.user.name.lowercased() }
            print("Photos were added")
            return sortedPhotos
    }
    

    func writeToBase(photoModel: PhotoModel?) {
        if photoModel != nil {
            remoteDatabase.child("photo_" + "\(photoModel!.id)").setValue(photoModel?.toDatabase())
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Write"), object: nil)
        }
    }

    func deleteFromBase(photoModel: PhotoModel?) {
        if photoModel != nil {
            remoteDatabase.child("photo_" + "\(photoModel!.id)").removeValue()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Delete"), object: nil)
        }
    }
    
    
    var baseId: [String] = []
    
    func checkFirebase() {

        var temporaryArray: [String] = []

        remoteDatabase.observe(.value, with: { snapshot in
            if snapshot.exists(){
                for child in snapshot.children {

                    if let snapshot = child as? DataSnapshot {

                        let value = snapshot.value as? [String: Any]
                        let id = value?["id"] as? String ?? ""

                        temporaryArray.append(id)
                    }
                }

                self.baseId = temporaryArray
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Check"), object: nil)
            } else {
                self.baseId = []
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Check"), object: nil)
            }

        })
        
    }
    
    
    func checkExistance(photoId: String, array: [String]) -> Bool {
        
        print("\(array)" + "asdsafsdfsd")

        if array.contains(photoId) {
            return true
        } else {
            return false
        }

    }
    

}
    






