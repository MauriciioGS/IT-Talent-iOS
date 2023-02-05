//
//  JobViewCell.swift
//  IT Talent
//
//  Created by Mauricio García S on 31/01/23.
//

import UIKit

class JobViewCell: UICollectionViewCell {
    
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var enterpriseLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var vacanciesLabel: UILabel!
    @IBOutlet weak var applicantsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 8
        self.layer.masksToBounds = false
    }

}
