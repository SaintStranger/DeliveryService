//
//  StringToImageConverter.swift
//  DeliveryService
//
//  Created by test on 13.05.2022.
//

import Foundation
import UIKit

// MARK: Не нашел куда добавить, поэтому вынес в отдельный файл
class StringToImageConverter {
    
    func gettingPhoto(urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        let photoData = try? Data(contentsOf: url)
        let photo = UIImage(data: photoData!)
        return photo
    }
    
}
