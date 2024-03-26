//
//  ResetPasswordViewController.swift
//  RentEasy
//
//  Created by CodeSomps on 2023-10-08.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    var button_FieldStyle = Button_FieldStyle()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button_FieldStyle.buttonShape(confirmButton)
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        guard let email = userEmailTextField.text, !email.isEmpty else {
                showAlert(message: "Enter your email.")
                return
            }
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                    return
                }
                
                self.showAlert(message: "Password reset link has been sent to \(email). Kindly follow the instruction to reset your password.", title: "Email Sent")
            }
        }
        
        func showAlert(message: String, title: String = "Alert") {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
