//
//  TestimonialTableViewCell.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-11-02.
//

import UIKit

class TestimonialTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewersName: UILabel!
    @IBOutlet weak var reviewersComment: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
