//
//  HousesViewController.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-11-18.
//

import UIKit

class HousesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var rentDataEntityProperty: [Property] = []
    var favoritePropertyIds: Set<String> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Family Homes"
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.register(UINib(nibName: "RentCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PropertyManager.shared.searchPropertiesByCategory(category: "Family Homes") { [weak self] (properties, error) in
            DispatchQueue.main.async {
                if let properties = properties {
                    self?.rentDataEntityProperty = properties
                    self?.tableView.reloadData()
                } else if let error = error {
                    print("Error loading properties \(error.localizedDescription)")
                }
            }
        }
        fetchFavoriteProperties()
    }
    
    func fetchFavoriteProperties() {
        PropertyManager.fetchFavoritePropertyIds { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ids):
                    self?.favoritePropertyIds = ids
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching favorite property IDs-> \(error)")
                }
            }
        }
    }
}

extension HousesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rentDataEntityProperty.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! RentCell
        let houses = rentDataEntityProperty[indexPath.row]
        cell.houses = houses
        cell.indexPath = indexPath
        cell.propertyName.text = houses.propertyName
        cell.rentStatus.text = houses.isBooked ? "Booked" : "Available"
        cell.rentStatus.textColor = houses.isBooked ? UIColor.red : UIColor.green
        
        if let firstImageUrlString = houses.imageUrls.first, let _ = URL(string: firstImageUrlString) {
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
            
            
            cell.propertyAmount.text = "$\(houses.propertyAmount) /month"
            cell.propertyAddress.text = houses.propertyAddress
            cell.propertySize.text = houses.propertyCategory
            let isFavorited = favoritePropertyIds.contains(houses.propertyID ?? "")
            cell.updateButtonImage(isFavorite: isFavorited)
            cell.cellStackView.layer.cornerRadius = 5
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowRadius = 2
            cell.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.layer.shadowOpacity = 1
        }
        return cell
    }
}

extension HousesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRentData = rentDataEntityProperty[indexPath.row]
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "DetailPageID") as? DetailPageViewController {
            destinationVC.selectedItem = selectedRentData
            navigationController?.pushViewController(destinationVC, animated: true)
        } else {
            print("Failed destinationVC.")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

