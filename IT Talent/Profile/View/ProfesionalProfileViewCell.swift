//
//  ProfesionalProfileViewCell.swift
//  IT Talent
//
//  Created by Mauricio García S on 04/02/23.
//

import UIKit

class ProfesionalProfileViewCell: UICollectionViewCell {
    
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var enterpriseLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!

    
    @IBOutlet weak var textAch: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.layer.cornerRadius = 10
        viewContainer.layer.shadowColor = UIColor.black.cgColor
        viewContainer.layer.shadowOpacity = 0.4
        viewContainer.layer.shadowOffset = CGSize(width: 4, height: 4)
        viewContainer.layer.shadowRadius = 8
        viewContainer.layer.masksToBounds = false
        
    }

}
