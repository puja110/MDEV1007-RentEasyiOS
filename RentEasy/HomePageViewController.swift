//
//  HomePageViewController.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-10-13.
//

import UIKit
import CoreLocation
import Kingfisher

class HomePageViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, CLLocationManagerDelegate {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryBackgroundStack3: UIStackView!
    @IBOutlet weak var categoryBackgroundStack1: UIStackView!
    @IBOutlet weak var categoryBackgroundStack2: UIStackView!
    @IBOutlet weak var categoryBackgroundStack: UIStackView!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var lowerAndUpperStackConstraints: NSLayoutConstraint!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var hScrollView: UIScrollView!
    @IBOutlet weak var lowerStackView: UIStackView!
    @IBOutlet weak var innerStack: UIStackView!
    @IBOutlet weak var hScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryButton1: UIButton!
    @IBOutlet weak var categoryButton2: UIButton!
    @IBOutlet weak var categoryButton3: UIButton!
    @IBOutlet weak var categoryButton4: UIButton!
    @IBOutlet weak var welcomeToRentEasy: UILabel!
    @IBOutlet weak var topSeeMore: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    
    //MARK: - Variables & Constants
    var searchBarAppearance = SearchBarAppearance()
    var buttonTextField = Button_FieldStyle()
    let categoryViewHeight: CGFloat = 160
    var properties: [Property] = []
    var favoritePropertyIds: Set<String> = []
    let locationManager = CLLocationManager()
    
    //MARK: - CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchProperties()
        fetchFavoriteProperties()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSetup()
        fetchProperties()
        searchTextField.delegate = self
        searchBarAppearance.glassAndFilterTextField(textField: searchTextField)
        searchTextField.becomeFirstResponder()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        buttonTextField.categoryStackAppearance(categoryBackgroundStack)
        buttonTextField.categoryStackAppearance(categoryBackgroundStack2)
        buttonTextField.categoryStackAppearance(categoryBackgroundStack1)
        buttonTextField.categoryStackAppearance(categoryBackgroundStack3)
        
        //MARK: - Gestures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSearchBar(_:)))
        searchTextField.addGestureRecognizer(tapGesture)
        
        let categoryOneGesture = UITapGestureRecognizer(target: self, action: #selector(stackOneViewTapped))
        categoryBackgroundStack1.addGestureRecognizer(categoryOneGesture)
        
        let categoryTwoGesture = UITapGestureRecognizer(target: self, action: #selector(stackTwoViewTapped))
        categoryBackgroundStack2.addGestureRecognizer(categoryTwoGesture)
        
        let categoryThreeGesture = UITapGestureRecognizer(target: self, action: #selector(stackThreeViewTapped))
        categoryBackgroundStack.addGestureRecognizer(categoryThreeGesture)
        
        let categoryFourGesture = UITapGestureRecognizer(target: self, action: #selector(stackFourViewTapped))
        categoryBackgroundStack3.addGestureRecognizer(categoryFourGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        hScrollView.delegate = self
        tableView.register(UINib(nibName: "RentCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
    }
    
    
    
    //MARK: - FETCH PROPERTIES
    func fetchProperties() {
        PropertyManager.fetchAllProperties { [weak self] fetchedProperties, error in
            DispatchQueue.main.async {
                if let properties = fetchedProperties {
                    self?.properties = properties
                    self?.tableView.reloadData()
                } else if let error = error {
                    print("Error fetching properties-> \(error.localizedDescription)")
                }
            }
        }
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

    
    //MARK: - Category Gestures
    @objc func stackOneViewTapped() {
        performSegue(withIdentifier: "CondoView", sender: self)
    }
    
    @objc func stackTwoViewTapped() {
        performSegue(withIdentifier: "FamilyHome", sender: self)
    }
    
    @objc func stackThreeViewTapped() {
        performSegue(withIdentifier: "StudentView", sender: self)
    }
    
    @objc func stackFourViewTapped() {
        performSegue(withIdentifier: "ContemporaryView", sender: self)
    }
    
    @objc func mapDoneButton() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - HOMEPAGE MAP
    @IBAction func mapIconPressed(_ sender: UIButton) {
        let destinationVC = UIStoryboard(name: "Main", bundle: nil)
        if let filterViewController = destinationVC.instantiateViewController(withIdentifier: "FilterView") as? FilterViewController {
            filterViewController.view.backgroundColor = UIColor.systemGray5
            filterViewController.searchTextField.isHidden = true
            filterViewController.mapToSafeArea.constant = 10
            if filterViewController.parent == nil {
                let navigationController = UINavigationController(rootViewController: filterViewController)
                filterViewController.title = "Accomodations near your location"
                filterViewController.sheetPresentationController?.preferredCornerRadius = 100
                let button = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(mapDoneButton))
                filterViewController.navigationItem.rightBarButtonItem = button
                navigationController.modalPresentationStyle = .popover
                self.present(navigationController, animated: true)
            } else {
                // DO NOTHING
            }
        }
    }
    
    //MARK: - Navigating to FilterViewController
    @objc func tapSearchBar(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "FavoriteView", sender: self)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    //MARK: - Navigation to Detail Page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPage" {
            if let destinationVC = segue.destination as? DetailPageViewController {
                if let selectedItem = sender as? Property? {
                    destinationVC.selectedItem = selectedItem
//                    destinationVC.favorite = selectedItem.isFavorite
                } else {
                    print("Not entity object")
                }
            } else {
                print("DestinationVC not found.")
            }
        }
    }
    
    //MARK: - HOMEPAGE ANIMATION
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        topSeeMore.isHidden = true
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        topSeeMore.isHidden = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let hide: CGFloat = categoryViewHeight
            let lowerStackHeight = tableView.contentOffset.y
            if lowerStackHeight >= hide {
                hScrollView.isHidden = true
                welcomeToRentEasy.isHidden = true
                categoryLabel.isHidden = true
                seeMoreButton.isHidden = true
                topSeeMore.isHidden = true
                lowerAndUpperStackConstraints.constant = 10
            } else {
                hScrollView.isHidden = false
                welcomeToRentEasy.isHidden = false
                topSeeMore.isHidden = false
                categoryLabel.isHidden = false
                lowerAndUpperStackConstraints.constant = 180
                seeMoreButton.isHidden = false
            }
            UIView.animate(withDuration: 0.2) {self.view.layoutIfNeeded()}
        }
    }
    
}

//MARK: - TableView dataSource
extension HomePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! RentCell
        let houses = properties[indexPath.row]
        cell.houses = houses
        cell.indexPath = indexPath
        cell.propertyName.text = houses.propertyName
        cell.propertyAmount.text = "$\(houses.propertyAmount) /month"
        cell.propertyAddress.text = houses.propertyAddress
        cell.rentStatus.text = houses.isBooked ? "Booked" : "Available"
        cell.rentStatus.textColor = houses.isBooked ? UIColor.red : UIColor.green
        
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

//MARK: -  TableView Deletage
extension HomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRentData = properties[indexPath.row]
        performSegue(withIdentifier: "DetailPage", sender: selectedRentData)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}


//MARK: - LABEL LOCATION UPDATE
extension HomePageViewController {
  private func locationSetup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, let placemark = placemarks?.first, let city = placemark.locality else { return }
            DispatchQueue.main.async {
                self.cityLabel.text = "\(city)"
            }
        }
    }
}

