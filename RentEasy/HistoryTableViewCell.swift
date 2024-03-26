//
//  HistoryTableViewCell.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-11-04.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var cellStackView: UIStackView!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var houseName: UILabel!
    @IBOutlet weak var houseAddress: UILabel!
    @IBOutlet weak var houseSize: UILabel!
    @IBOutlet weak var houseAmount: UILabel!
    @IBOutlet weak var houseStatus: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageLabel.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
