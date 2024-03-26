//
//  ProfileViewController.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-10-21.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userEmailAddress: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var profileDetailsStackView: UIStackView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var securityPrivacyView: UIView!
    @IBOutlet weak var paymentDetailsView: UIView!
    
    var buttonFieldStyle = Button_FieldStyle()
    var viewLine = Button_FieldStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        buttonFieldStyle.customButtonShape(settingView)
        buttonFieldStyle.customButtonShape(securityPrivacyView)
        buttonFieldStyle.customButtonShape(paymentDetailsView)
        buttonFieldStyle.buttonShape(logoutButton)
        buttonFieldStyle.viewLine(profileDetailsStackView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        guard let profileDetails = UserManager.shared.currentUser else {return}
        clientName.text = "\(profileDetails.firstName )  \(profileDetails.lastName)"
        userEmailAddress.text = profileDetails.email
        
        if let urlString = profileDetails.profileImageUrl, let url = URL(string: urlString) {
            profilePicture.kf.setImage(with: url, placeholder: UIImage(named: "profilePic3"))
        } else {
            profilePicture.image = UIImage(named: "profilePic3")
        }
    }
    
    
    @IBAction func settingsButton(_ sender: UIButton) {
        print("Settings Pressed")
    }
    
    @IBAction func paymentDetailsButton(_ sender: UIButton) {
        print("PaymentButtonPressed")
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.logOut()
        }
        
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(yes)
        alertController.addAction(no)
        present(alertController, animated: true, completion: nil)
    }
    
    func logOut() {
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginPage") {
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
    }
}
