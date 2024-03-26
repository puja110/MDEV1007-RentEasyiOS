//
//  SearchBarAppearance.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-11-04.
//

import Foundation
import UIKit


struct SearchBarAppearance {
    func glassAndFilterTextField(textField: UITextField) {
        let magnifyingGlassSymbol = UIImage(systemName: "magnifyingglass")
        let magnifyingGlassView = UIImageView(image: magnifyingGlassSymbol)
        magnifyingGlassView.backgroundColor = UIColor(named: "systemGray")
        magnifyingGlassView.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        magnifyingGlassView.tintColor = UIColor.black
        magnifyingGlassView.contentMode = .center
        let paddingConstant = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        paddingConstant.addSubview(magnifyingGlassView)
        textField.leftView = paddingConstant
        textField.leftViewMode = .always
        
         let filterImage = UIImage(systemName: "slider.vertical.3")
         let filterImageButton = UIButton(type: .custom)
         filterImageButton.setImage(filterImage, for: .normal)
         filterImageButton.tintColor = UIColor.black
        filterImageButton.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
         let paddingRight = UIView(frame: filterImageButton.frame)
         paddingRight.addSubview(filterImageButton)
         textField.rightView = paddingRight
         textField.rightViewMode = .always
        textField.layer.cornerRadius = 15.0
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.2
        textField.layer.shadowColor = UIColor.systemGray5.cgColor
        textField.layer.shadowRadius = 2
        textField.layer.shadowOffset = CGSize(width: 2, height: 2)
        textField.layer.shadowOpacity = 0.9
    }
    func magnifyingGlassOnly(_ textField: UITextField) {
        let magnifyingGlassImage = UIImage(systemName: "magnifyingglass")
        let magnifyingGlassView = UIImageView(image: magnifyingGlassImage)
        magnifyingGlassView.backgroundColor = UIColor(named: "systemGray")
        magnifyingGlassView.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        magnifyingGlassView.tintColor = UIColor.black
        magnifyingGlassView.contentMode = .center
        let paddingConstant = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        paddingConstant.addSubview(magnifyingGlassView)
        textField.leftView = paddingConstant
        textField.leftViewMode = .always
    }
}

