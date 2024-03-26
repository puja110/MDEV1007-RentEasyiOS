//
//  SettingsViewController.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-12-03.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let profileDetails = UserManager.shared.currentUser else {return}
        firstNameTextField.text = profileDetails.firstName
        lastNameTextField.text = profileDetails.lastName
        emailTextField.text = profileDetails.email
        phoneNumberTextField.text = profileDetails.phoneNumber
        
        if let urlString = profileDetails.profileImageUrl, let url = URL(string: urlString) {
            profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profilePic3"))
        } else {
            profileImage.image = UIImage(named: "profilePic3")
        }
    }
    
    
    @IBAction func updatePicture(_ sender: UIButton) {
        uploadImage()
    }
    
    
    @IBAction func onUpdateProfile(_ sender: UIButton) {
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let email = emailTextField.text!
        let phoneNumber = phoneNumberTextField.text!
        
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !phoneNumber.isEmpty else {
            print("Fields cannot be empty")
            showAlert(message: "Fields cannot be empty. Please try again!")
            return
        }
        
        UserManager.shared.updateUserDetails(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.showAlertWithDismiss(message: "Profile updated successfully.")
                } else if let error = error {
                    self.showAlert(message: "Failed to update profile-> \(error.localizedDescription)")
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithDismiss(message: String, title: String = "Success") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}


extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage.image = selectedImage
        
        UserManager.shared.updateProfileImage(userId: UserManager.shared.currentUserId ?? "", image: selectedImage) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.showAlert(message: "Profile image updated successfully.")
                } else {
                    self.showAlert(message: "Failed to update profile image:- \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage() {
        let alertController = UIAlertController(title: "Choose Picture", message: "Select a picture from?", preferredStyle: .actionSheet)
           
           if UIImagePickerController.isSourceTypeAvailable(.camera) {
               let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                   self?.presentImagePicker(sourceType: .camera)
               }
               alertController.addAction(cameraAction)
           }
           
           let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
               self?.presentImagePicker(sourceType: .photoLibrary)
           }
           alertController.addAction(photoLibraryAction)
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
           alertController.addAction(cancelAction)
           
           present(alertController, animated: true)
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }

}
