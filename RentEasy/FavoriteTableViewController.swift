//
//  FavoriteTableViewController.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-11-02.
//

import UIKit
import CoreData



class FavoriteTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesTitle: UILabel!
    var buttonTextField = Button_FieldStyle()
    var rentDataEntityProperty: [Property] = []
    var favoritePropertyIds: Set<String> = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        fetchFavoriteProperties()
        tableView.reloadData()
        favoritesTitle.isHidden = rentDataEntityProperty.isEmpty ? true : false
        tableView.backgroundView = rentDataEntityProperty.isEmpty ? buttonTextField.emptyCheck(with: "No favorite property") : nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "RentCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "CustomCell")
    }
    
    
    func fetchFavoriteProperties() {
        PropertyManager.fetchFavoritePropertyIds { [weak self] result in
            switch result {
            case .success(let ids):
                self?.fetchPropertiesByIds(ids)
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error fetching favorite property IDs-> \(error)")
                }
            }
        }
    }
    
    private func fetchPropertiesByIds(_ ids: Set<String>) {
        PropertyManager.fetchFavoriteProperties(byIds: ids) { [weak self] properties in
            DispatchQueue.main.async {
                self?.rentDataEntityProperty = properties
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: -  TableView Delegate
extension FavoriteTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRentData = rentDataEntityProperty[indexPath.row]
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "DetailPageID") as? DetailPageViewController {
            destinationVC.selectedItem = selectedRentData
//            destinationVC.favorite = selectedRentData.isFavorite
            navigationController?.pushViewController(destinationVC, animated: true)
        } else {
            print("Failed.")
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
}



//MARK: -  DataSource
extension FavoriteTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rentDataEntityProperty.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! RentCell
        let houses = rentDataEntityProperty[indexPath.row]
        cell.houses = houses
        cell.delegate = self
        cell.indexPath = indexPath
        cell.propertyName.text = houses.propertyName
        cell.propertyAmount.text = "$\(houses.propertyAmount) /month"
        cell.propertyAddress.text = houses.propertyAddress

        DispatchQueue.main.async {
             cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
         }
        
        if let imageUrl = houses.imageUrls.first, let url = URL(string: imageUrl) {
             cell.propertyImage.kf.indicatorType = .activity
             cell.propertyImage.kf.setImage(
                 with: url,
                 placeholder: UIImage(named: "houseTwo"),
                 options: [
                     .transition(.fade(0.2)),
                     .cacheOriginalImage
                 ])
         }
        
        cell.propertySize.text = houses.propertyCategory
        let isFavorited = favoritePropertyIds.contains(houses.propertyID ?? "")
        cell.updateButtonImage(isFavorite: isFavorited)
        cell.cellStackView.layer.cornerRadius = 5
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowRadius = 2
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowOpacity = 1
        return cell
    }
}


extension FavoriteTableViewController: RentCellDelegate {
    func didTapFavoriteButton(in cell: RentCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        rentDataEntityProperty.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
