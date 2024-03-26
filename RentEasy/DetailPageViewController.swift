//
//  DetailPageViewController.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-10-26.
//

import UIKit
import SwiftUI

class DetailPageViewController: UIViewController, UIViewControllerTransitioningDelegate {
      
    @IBOutlet weak var favButtonImage: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var houseAddress: UILabel!
    @IBOutlet weak var leaveReview: UIButton!
    @IBOutlet weak var collectionViewMain: UICollectionView!
    @IBOutlet weak var houseName: UILabel!
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var thirdStackView: UIStackView!
    @IBOutlet weak var houseSize: UILabel!
    @IBOutlet weak var propertyManagerImage: UIImageView!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var fourthStackView: UIStackView!
    @IBOutlet weak var fifthStackView: UIStackView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var bookButtonView: UIView!
    @IBOutlet weak var bookAvailableLabel: UILabel!
    @IBOutlet weak var propertyOwnerName: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet var propertyManagerRatingImageViews: [UIImageView]!

    var buttonTextField = Button_FieldStyle()
    var rentDataEntityProperty: Property?
    var testimonials: [Testimonial] = []
    var selectedItem: Property? {
          didSet {
             rentDataEntityProperty = selectedItem
              tableView?.reloadData()
          }
      }
    
    var favorite: Bool = false {
        didSet {
            favoriteButtonState()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        fetchRatings()
        fetchRatingForPropertyManager()
        fetchPropertyManagerInfo()
        //MARK: DISABLING UI
        let posterID = UserManager.shared.currentUserId
        if selectedItem?.posterUserID == posterID {
            bookButton.isEnabled = false
            leaveReview.isEnabled = false
            bookButtonView.backgroundColor = .lightGray
        }
    }
    
    //MARK: - FETCH RATING FOR TESTIMONIES
    func fetchRatings() {
        if let posterUserID = selectedItem?.posterUserID {
            RatingManager.shared.fetchRatings(for: posterUserID) { [weak self] fetchedTestimonials in
                DispatchQueue.main.async {
                    self?.testimonials = fetchedTestimonials
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        let destinationVC = UIStoryboard(name: "Main", bundle: nil)
        if let filterViewController = destinationVC.instantiateViewController(withIdentifier: "FilterView") as? FilterViewController {
            filterViewController.selectedProperty = selectedItem
            filterViewController.view.backgroundColor = UIColor.systemGray5
            filterViewController.searchTextField.isHidden = true
            filterViewController.mapToSafeArea.constant = 10
            if filterViewController.parent == nil {
                let navigationController = UINavigationController(rootViewController: filterViewController)
                filterViewController.title = "Property Address"
                filterViewController.sheetPresentationController?.preferredCornerRadius = 100
                let button = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(doneButton))
                filterViewController.navigationItem.rightBarButtonItem = button
                navigationController.modalPresentationStyle = .popover
                self.present(navigationController, animated: true)
            } else {
               // DO NOTHING
            }
        }
    }
    
    @objc func doneButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func favoriteButtonState() {
        guard let image = UIImage(systemName: favorite ? "heart.fill" : "heart") else {return}
        favButtonImage?.setImage(image, for: .normal)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        guard let propertyToShare = rentDataEntityProperty else { return }
        let name = propertyToShare.propertyName
        let address = propertyToShare.propertyAddress
        let shareMessage = "Check out this beautiful \(name ) in \(address )"
        let activity = UIActivityViewController(activityItems: [shareMessage, propertyToShare.imageUrls.first as Any], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func bookingButtonPressed(_ sender: UIButton) {
        presentAlert()
    }
    
    func presentAlert() {
        let customAlert = CustomAlert(nibName: "CustomAlert", bundle: nil)
        customAlert.houses = selectedItem
        customAlert.modalPresentationStyle = .overCurrentContext
        present(customAlert, animated: true, completion: nil)
    }
    
    @IBAction func leaveReviewButtonPressed(_ sender: UIButton) {
        let ratingView = RatingView(posterUserID: selectedItem?.posterUserID ?? "")
          let hostingController = UIHostingController(rootView: ratingView)
          hostingController.modalPresentationStyle = .overFullScreen
          hostingController.view.backgroundColor = UIColor.clear
          self.present(hostingController, animated: true, completion: nil)
    }
}

extension DetailPageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedItem?.imageUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewMain.dequeueReusableCell(withReuseIdentifier: "ImageCells", for: indexPath) as! DetailCollectionCell

        if let urlString = selectedItem?.imageUrls[indexPath.row],
           let url = URL(string: urlString) {
            cell.imageForCell.kf.setImage(with: url)
        }
        
        return cell
    }
}

extension DetailPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testimonials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestimonialCell", for: indexPath)as! TestimonialTableViewCell
        let comments = testimonials[indexPath.row]
        cell.reviewersName.text = comments.name
        cell.reviewersComment.text = comments.comment
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}

//MARK: - CONFIGURE PAGE
extension DetailPageViewController {
    func configureView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        buttonTextField.viewLine(firstStackView)
        buttonTextField.viewLine(secondStackView)
        buttonTextField.viewLine(thirdStackView)
        buttonTextField.viewLine(fourthStackView)
        buttonTextField.bookButtonShape(bookButtonView)
        
        houseName.text = rentDataEntityProperty?.propertyName
        houseAddress.text = rentDataEntityProperty?.propertyAddress
        amountLabel.text = "$\(rentDataEntityProperty?.propertyAmount ?? 0) /month"
        houseSize.text = rentDataEntityProperty?.propertySize
        
        if ((rentDataEntityProperty?.description.isEmpty) != nil) {
            descriptionText.text = rentDataEntityProperty?.description
        } else {
            descriptionText.text = "This is a beautiful and cozy home which woould be perfect for those who are searching for small yet enviroment friendly place. "
        }
        
        favoriteButtonState()
        
        tableView.register(UINib(nibName: "TestimonialTableViewCell", bundle: nil), forCellReuseIdentifier: "TestimonialCell")
        
        collectionViewMain.register(DetailCollectionCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionViewMain.delegate = self
        collectionViewMain.dataSource = self
        
        if selectedItem?.isBooked == true {
            bookButtonView.backgroundColor = .lightGray
        }
        bookButton.isEnabled = selectedItem?.isBooked == true ? false : true
        if selectedItem?.isBooked == true {
            bookAvailableLabel.text = "Not Available"
        }
    }
    
}

//MARK: - PROPERTY MANAGER SECTION
extension DetailPageViewController {
    func updatePropertyManagerRatingSection() {
        guard !testimonials.isEmpty else {
            return
        }
        let totalRating = testimonials.reduce(0) { $0 + $1.rating }
        let averageRating = Double(totalRating) / Double(testimonials.count)
        print("Average rating-> \(averageRating)")
        updateStars(averageRating)
    }

    func updateStars(_ averageRating: Double) {
        let fullStarCount = Int(averageRating)
        let hasHalfStar = averageRating.truncatingRemainder(dividingBy: 1) >= 0.5
        
        for (index, imageView) in propertyManagerRatingImageViews.enumerated() {
            if index < fullStarCount {
                imageView.image = UIImage(systemName: "star.fill")
            } else if hasHalfStar && index == fullStarCount {
                imageView.image = UIImage(named: "halfStar")
            } else {
                imageView.image = UIImage(systemName: "star")
            }
        }
    }
    
    func fetchRatingForPropertyManager() {
        if let posterUserID = selectedItem?.posterUserID {
            RatingManager.shared.fetchRatings(for: posterUserID) { [weak self] fetchedTestimonials in
                DispatchQueue.main.async {
                    self?.testimonials = fetchedTestimonials
                    self?.tableView.reloadData()
                    self?.updatePropertyManagerRatingSection()
                }
            }
        }
    }
    
    func fetchPropertyManagerInfo() {
        if let posterUserID = selectedItem?.posterUserID {
            PropertyManagerModel.shared.fetchPropertyManagerDetails(by: posterUserID) { [weak self] result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self?.updatePropertyManagerDetails(with: user)
                    }
                case .failure(let error):
                    print("Error fetching user-> \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updatePropertyManagerDetails(with user: User) {
        self.propertyOwnerName.text = "\(user.firstName) \(user.lastName)"
        if let profileImageUrl = user.profileImageUrl, let url = URL(string: profileImageUrl) {
            self.propertyManagerImage.kf.setImage(with: url)
        } else {
            self.propertyManagerImage.image = UIImage(named: "profilePic3")
        }
        propertyManagerImage.layer.cornerRadius = propertyManagerImage.frame.size.width / 2
    }
}


