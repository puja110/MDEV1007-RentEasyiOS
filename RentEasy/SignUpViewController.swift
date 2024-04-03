//
//  SignUpViewController.swift
//  RentEasy
//
//  Created by CodeSomps on 2023-10-08.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var alreadyHaveAnAccountLabel: UILabel!
    
    var button_FieldStyle = Button_FieldStyle()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button_FieldStyle.buttonShape(signUpButton)
        button_FieldStyle.textFieldShape(firstNameTextField)
        button_FieldStyle.textFieldShape(lastNameTextField)
        button_FieldStyle.textFieldShape(emailTextField)
        button_FieldStyle.textFieldShape(phoneNumberTextField)
        button_FieldStyle.textFieldShape(passwordTextField)
        button_FieldStyle.textFieldShape(confirmPasswordTextField)
        button_FieldStyle.buttonShape(signUpButton)
        secureEye(passwordTextField)
        secureEye(confirmPasswordTextField)
        
        let alreadyHaveAccountGesture = UITapGestureRecognizer(target: self, action: #selector(alreadyHaveAnAccountLabelTapped))
               alreadyHaveAnAccountLabel.isUserInteractionEnabled = true
               alreadyHaveAnAccountLabel.addGestureRecognizer(alreadyHaveAccountGesture)
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
                 let password = passwordTextField.text,
                 let phoneNumber = phoneNumberTextField.text,
                 let firstName = firstNameTextField.text,
                 let lastName = lastNameTextField.text,
                 let confirmPassword = confirmPasswordTextField.text,
                 !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !phoneNumber.isEmpty, !firstName.isEmpty, !lastName.isEmpty,
                 password == confirmPassword else {
               alertMessage(title: "Error", message: "Please check inputs.")
               return
           }
           
           Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
               if let error = error {
                   self.alertMessage(title: "Error", message: error.localizedDescription)
                   return
               }
               
               guard let user = authResult?.user else { return }
               let db = Firestore.firestore()
               
               // Creating user doc
               db.collection("users").document(user.uid).setData([
                   "firstName": firstName,
                   "lastName": lastName,
                   "email": email,
                   "phoneNumber": phoneNumber
               ]) { err in
                   if let err = err {
                       print("Error writing document-> \(err)")
                       self.alertMessage(title: "Error", message: "Failed to save user info.")
                   } else {
                       user.sendEmailVerification { error in
                           if let error = error {
                               self.alertMessage(title: "Verification Failed", message: error.localizedDescription)
                           } else {
                               self.performSegueToVerifyEmailVC()
                           }
                       }
                   }
               }
           }
       }
    
      func alertMessage(title: String, message: String) {
          let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let oK = UIAlertAction(title: "OK", style: .default)
          alertController.addAction(oK)
          present(alertController, animated: true, completion: nil)
      }
      
      @objc func alreadyHaveAnAccountLabelTapped() {
          customSegue()
      }
      
      private func customSegue() {
          guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginPage") else { return }
          loginVC.modalPresentationStyle = .fullScreen
          present(loginVC, animated: true, completion: nil)
      }
    
    private func performSegueToVerifyEmailVC() {
        if let verifyEmailVC = storyboard?.instantiateViewController(withIdentifier: "VerifyEmailVC") as? VerifyEmailViewController {
            verifyEmailVC.modalPresentationStyle = .fullScreen
            verifyEmailVC.userEmail = emailTextField.text
            present(verifyEmailVC, animated: true, completion: nil)
        }
    }
      
      private func secureEye(_ textField: UITextField) {
          let passwordImage = UIImage(systemName: "eye.slash")
          let passwordImageButton = UIButton(type: .custom)
          passwordImageButton.setImage(passwordImage, for: .normal)
          passwordImageButton.tintColor = UIColor.black
          passwordImageButton.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
          let paddingRightConstant = UIView(frame: passwordImageButton.frame)
          paddingRightConstant.addSubview(passwordImageButton)
          textField.rightView = paddingRightConstant
          textField.rightViewMode = .always
          passwordImageButton.addTarget(self, action: #selector(secureEyePressed(_:)), for: .touchUpInside)
      }

      @objc func secureEyePressed(_ sender: UIButton) {
          if let textField = sender.superview?.superview as? UITextField {
              textField.isSecureTextEntry.toggle()
              let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
              let image = UIImage(systemName: imageName)
              sender.setImage(image, for: .normal)
          }
      }
  }
