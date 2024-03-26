//
//  DetailCollectionCell.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-11-19.
//

import UIKit

class DetailCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageForCell: UIImageView!
    
    override func awakeFromNib() {
          super.awakeFromNib()
        imageForCell.contentMode = .scaleAspectFill
        imageForCell.clipsToBounds = true
      }
}
