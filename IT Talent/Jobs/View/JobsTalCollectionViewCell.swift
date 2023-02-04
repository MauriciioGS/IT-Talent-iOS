//
//  JobsTalCollectionViewCell.swift
//  IT Talent
//
//  Created by Mauricio García S on 03/02/23.
//

import UIKit

class JobsTalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var enterpriseLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var vacanciesLabel: UILabel!
    @IBOutlet weak var applicantsLabel: UILabel!
    @IBOutlet weak var wageLabel: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.layer.cornerRadius = 10
        viewContainer.layer.shadowColor = UIColor.lightGray.cgColor
        viewContainer.layer.shadowOpacity = 0.8
        viewContainer.layer.shadowOffset = .zero
        viewContainer.layer.shadowRadius = 10
        viewContainer.layer.shadowPath = UIBezierPath(rect: viewContainer.bounds).cgPath
        viewContainer.layer.shouldRasterize = true
        viewContainer.layer.rasterizationScale = UIScreen.main.scale
    }

}
