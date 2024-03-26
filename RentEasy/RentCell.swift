//
//  RentCell.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-10-17.
//

import UIKit
import FirebaseFirestore

protocol RentCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: RentCell)
}

class RentCell: UITableViewCell {
    
    @IBOutlet weak var rentCustomCell: UIView!
    @IBOutlet weak var propertyName: UILabel!
    @IBOutlet weak var rentStatus: UILabel!
    @IBOutlet weak var propertyAddress: UILabel!
    @IBOutlet weak var propertySize: UILabel!
    @IBOutlet weak var propertyAmount: UILabel!
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var cellStackView: UIStackView!
    @IBOutlet weak var favoriteButton: UIButton!
    var buttonTextField = Button_FieldStyle()
    var indexPath: IndexPath?
    var tableView: UITableView?
    weak var delegate: RentCellDelegate?
    var houses: Property? {
        didSet {
            guard houses != nil else { return }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        propertyImage.layer.cornerRadius = 5
        propertyImage.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteButton.isSelected = false
        
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let propertyId = houses?.propertyID,
              let userId = UserManager.shared.currentUserId else {
            print("Missing propertyId or userId")
            return
        }
        
        print("UserID-> \(userId)")
        
        let db = Firestore.firestore()
        let favoriteRef = db.collection("users").document(userId).collection("favorites").document(propertyId)
        
        favoriteRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                favoriteRef.delete() { err in
                    if let err = err {
                        print("Error removing document-: \(err)")
                    } else {
                        print("Document successfully removed.")
                        DispatchQueue.main.async {
                            self.updateButtonImage(isFavorite: false)
                        }
                    }
                }
            } else {
                favoriteRef.setData([
                    "propertyId": propertyId
                ]) { err in
                    if let err = err {
                        print("Error adding document:- \(err)")
                    } else {
                        print("Document successfully added.")
                        DispatchQueue.main.async {
                            self.updateButtonImage(isFavorite: true)
                        }
                    }
                }
            }
        }
        delegate?.didTapFavoriteButton(in: self)
    }
    
    func updateButtonImage(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.setImage(image, for: .selected)
    }
    
    func configureFavoriteButton(alwaysFilled: Bool) {
          let imageName = alwaysFilled ? "heart.fill" : "heart"
          favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
      }
    
}
