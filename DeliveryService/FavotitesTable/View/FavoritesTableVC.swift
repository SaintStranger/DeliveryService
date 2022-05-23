//
//  FavoritesTableVC.swift
//  DeliveryService
//
//  Created by test on 04.05.2022.
//

import UIKit

class FavoritesTableVC: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var presenter: FavortitesViewPresenterProtocol!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск по избранному"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Избранное"
        tabBarItem.title = "Избранное"
        tabBarItem.image = UIImage(systemName: "star.fill")
        
        
        
        tableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoritesTableViewCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Deleted TableVC")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return presenter.model?.count ?? 0
        

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell") as? FavoritesTableViewCell {
            
            let photo = presenter.model?[indexPath.row]
            
            cell.name.text = photo?.user.name
            cell.previewImage.image = presenter.gettingPhoto(urlString: photo?.photos.small ?? "")
            return cell
        
        }
        
        return UITableViewCell()
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
                
            guard let model = presenter.model?[indexPath.row] else { return }
            presenter.model?.remove(at: indexPath.row)
            self.presenter.deleteData(model: model)
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = presenter.model?[indexPath.row]
        presenter.showDetails(photo: photo)
    }

}


extension FavoritesTableVC: FavortitesViewProtocol {
    func updateTable() {
        tableView.reloadData()
    }

}

extension FavoritesTableVC: UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {

        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        if text != "" {
            let filtered = presenter.model?.filter{ $0.user.name.lowercased().contains(text) }
            presenter.model = filtered
            tableView.reloadData()
        } else {
            presenter.viewPhotoChecking()
        }


    }


    
}
