//
//  SettingsViewController.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-12-03.
//

import Foundation
import UIKit
import FirebaseAuth

class SecurityPrivacyViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let profileDetails = UserManager.shared.currentUser else {return}
        emailField.text = profileDetails.email
    }
    
    @IBAction func onPasswordUpdate(_ sender: UIButton) {
        guard let email = emailField.text, !email.isEmpty else {
            showAlert(message: "Enter your email.")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            self.showAlert(message: "Password reset link has been sent to \(email). Kindly follow the instruction to reset your password.", title: "Email Sent") {
//                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func showAlert(message: String, title: String = "Alert", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
