//
//  CustomAlert.swift
//  RentEasy
//
//  Created by Oladipupo Olasile on 2023-11-30.
//

import UIKit
import FirebaseFirestore

class CustomAlert: UIViewController {

    @IBOutlet weak var clientName: UITextField!
    @IBOutlet weak var clientEmail: UITextField!
    @IBOutlet weak var clientMessage: UITextField!
    @IBOutlet weak var alertStackView: UIStackView!
    @IBOutlet weak var alertView: UIView!
    var houses: Property?
    var detailPageVC = DetailPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertView.layer.cornerRadius = 40
        alertView.layer.borderWidth = 1
        alertView.layer.borderColor = UIColor.gray.cgColor
        alertStackView.layer.cornerRadius = 40
        
        clientName.layer.borderWidth = 0.8
        clientName.layer.borderColor = UIColor.green.cgColor
        
        clientEmail.layer.borderWidth = 0.8
        clientEmail.layer.borderColor = UIColor.green.cgColor
        
        clientMessage.layer.borderWidth = 0.8
        clientMessage.layer.borderColor = UIColor.green.cgColor
    }

    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard let name = clientName.text, !name.isEmpty,
                let email = clientEmail.text, !email.isEmpty,
                let message = clientMessage.text, !message.isEmpty,
                let propertyId = houses?.propertyID,
                let posterUserId = houses?.posterUserID else {
              let alert = UIAlertController(title: "Error", message: "Please fill all fields.", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              present(alert, animated: true)
              return
          }

          let bookingData: [String: Any] = [
              "clientName": name,
              "clientEmail": email,
              "clientMessage": message,
              "propertyID": propertyId,
              "bookingDate": Timestamp(date: Date()),
              "isBooked": true
          ]

          let db = Firestore.firestore()
          db.collection("users").document(posterUserId).collection("userBookings").addDocument(data: bookingData) { error in
              if let error = error {
                  print("Error saving booking-> \(error.localizedDescription)")
                  let alert = UIAlertController(title: "Booking Failed", message: "Please try again.", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                  self.present(alert, animated: true)
              } else {
                  self.markPropertyBooked(propertyId: propertyId)
                  self.bookingSuccessAlert()
              }
          }
      }

      func markPropertyBooked(propertyId: String) {
          let db = Firestore.firestore()
          db.collection("properties").document(propertyId).updateData(["isBooked": true]) { error in
              if let error = error {
                  print("Error updating property \(error.localizedDescription)")
              } else {
                  print("Property successfully booked.")
              }
          }
      }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func bookingSuccessAlert() {
        let alert = UIAlertController(title: "Booking Successful", message: "Booking successfully saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        self.dismiss(animated: true)
    }
    
}
