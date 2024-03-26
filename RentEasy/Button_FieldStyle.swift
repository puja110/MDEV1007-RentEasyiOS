//
//  Button&FieldStyle.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-10-20.
//

import Foundation
import UIKit

struct Button_FieldStyle {
    func buttonShape(_ button: UIButton) {
        button.layer.cornerRadius = 10.0
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 1
    }
    func textFieldShape(_ textField: UITextField) {
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 0.2
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowRadius = 1
        textField.layer.shadowOffset = CGSize(width: 1, height: 0.5)
        textField.layer.shadowOpacity = 0.3
        textField.backgroundColor = UIColor.systemGray6
    }
    func customButtonShape(_ uiView: UIView) {
        uiView.layer.cornerRadius = 10.0
        uiView.layer.shadowColor = UIColor.black.cgColor
        uiView.layer.shadowRadius = 1
        uiView.layer.shadowOffset = CGSize(width: 1, height: 1)
        uiView.layer.shadowOpacity = 0.8
    }
    func categoryStackAppearance(_ stackView: UIStackView) {
        stackView.layer.cornerRadius = 10
        stackView.layer.shadowRadius = 1
        stackView.layer.shadowOffset = CGSize(width: 0.5, height: 0)
        stackView.layer.shadowOpacity = 0.3
        stackView.layer.shadowColor = UIColor.black.cgColor
    }
    func viewLine(_ stackView: UIStackView) {
        let borderline = CALayer()
        borderline.backgroundColor = UIColor.gray.cgColor
        let width = stackView.bounds.width
        let height: CGFloat = 0.2
        borderline.frame = CGRect(x: 0, y: stackView.bounds.height - height, width: width, height: height)
        stackView.layer.addSublayer(borderline)
    }
    
    func changeButtonAppearance(myButton: UIButton) {
        myButton.layer.borderWidth = 2.0
        myButton.layer.borderColor = UIColor.black.cgColor
        myButton.layer.cornerRadius = 10.0
    }
    
    func bookButtonShape(_ uiView: UIView) {
        uiView.layer.cornerRadius = 20.0
        uiView.layer.shadowColor = UIColor.gray.cgColor
        uiView.layer.shadowRadius = 2
        uiView.layer.shadowOffset = CGSize(width: 1, height: 1)
        uiView.layer.shadowOpacity = 1
    }
    
    func emptyCheck(with message: String) -> UIView {
        let emptyTableLabel = UILabel()
        emptyTableLabel.text = message
        emptyTableLabel.textColor = .gray
        emptyTableLabel.textAlignment = .center
        emptyTableLabel.numberOfLines = 0
        return emptyTableLabel
    }
}
