//
//  VerifyEmailViewController.swift
//  RentEasy
//
//  Created by CodeSomps on 2023-10-08.
//

import UIKit
import FirebaseAuth

class VerifyEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resendEmailButton: UIButton!
    @IBOutlet weak var checkVerificationButton: UIButton!
    
    var button_FieldStyle = Button_FieldStyle()
    var userEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = userEmail
    }
    
    
    private func uiField() {
        button_FieldStyle.textFieldShape(emailTextField)
        button_FieldStyle.buttonShape(resendEmailButton)
        button_FieldStyle.buttonShape(checkVerificationButton)
        
        emailTextField.isEnabled = false
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser, !user.isEmailVerified else {
            showAlert("User not logged in or already verified.")
            return
        }
        
        user.sendEmailVerification { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert("Failed to resend verification email-> \(error.localizedDescription)")
            } else {
                self.showAlert("Verification email resent successfully.")
            }
        }
    }
    
    @IBAction func checkVerificationButtonPressed(_ sender: UIButton) {
        Auth.auth().currentUser?.reload { [weak self] error in
            guard let self = self, let user = Auth.auth().currentUser else { return }
            if let error = error {
                self.showAlert("Error refreshing user-> \(error.localizedDescription)")
            } else if user.isEmailVerified {
                self.showAlertSuccess("Email verified successfully!")
                
            } else {
                self.showAlert("Verify email. Check email inbox.")
            }
        }
        
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertSuccess(_ message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigateToLogin()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

    private func navigateToLogin() {
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginPage") as? LoginViewController {
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
    }}
