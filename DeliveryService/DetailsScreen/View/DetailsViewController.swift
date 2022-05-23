//
//  DetailsViewController.swift
//  DeliveryService
//
//  Created by test on 10.05.2022.
//

import UIKit
import Alamofire

class DetailsViewController: UIViewController {

    @IBOutlet weak var bigImageView: UIImageView!
    
    @IBOutlet weak var author: UILabel!

    @IBOutlet weak var date: UILabel!

    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var likes: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var presenter: DetailsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setPhoto()
        presenter.checkPhoto()
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Deleted DetailVC")
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        
        if self.button.tag == 1 {
            showAlertRemoved()
            presenter.removeFromBase()
            presenter.checkPhoto()
            button.tag = 0
        } else {
            showAlertAdded()
            presenter.writeToBase()
            presenter.checkPhoto()
            button.tag = 1
        }
        
    }
    
}



extension DetailsViewController: DetailsViewProtocol {
    
    func setButton(title: String, tag: Int) {
        self.button.setTitle(title, for: .normal)
        self.button.tag = tag
    }
    
    
    func setPhoto(photo: PhotoModel?) {
        let bigImage = presenter.gettingPhoto(urlString: photo?.photos.regular ?? "")
        bigImageView.image = bigImage
        author.text = photo?.user.name
        location.text = photo?.location?.title
        likes.text = "\(photo?.likes ?? 0)"
        
        
        
        //MARK: Приведение даты
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let originalFormat = dateFormatter.date(from: photo?.date ?? "")
        guard originalFormat != nil else { return }
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let formattedDate = dateFormatter.string(from: originalFormat!)
        date.text = formattedDate
    
    }
    
    
    func showAlertAdded() {
        let alert = UIAlertController(title: "", message: "Фотография добавлена в избранное", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }

    func showAlertRemoved() {
        let alert = UIAlertController(title: "", message: "Фотография убрана из избранного", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }

}


