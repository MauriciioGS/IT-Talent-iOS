//
//  JobRecruitmentViewCell.swift
//  IT Talent
//
//  Created by Mauricio García S on 05/02/23.
//

import UIKit

class JobRecruitmentViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cointarnerView: UIView!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var enterpriseLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var applicantsLabel: UILabel!
    @IBOutlet weak var vacanciesLabel: UILabel!
    @IBOutlet weak var rejectedLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cointarnerView.layer.cornerRadius = 10
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 8
        self.layer.masksToBounds = false
        
    }

}
