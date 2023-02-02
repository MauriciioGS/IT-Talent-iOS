//
//  TalentViewCell.swift
//  IT Talent
//
//  Created by Mauricio García S on 01/02/23.
//

import UIKit

class TalentViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellViewCOntainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profRoleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var yearsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellViewCOntainer.layer.cornerRadius = 10
        
        cellViewCOntainer.layer.shadowColor = UIColor.lightGray.cgColor
        cellViewCOntainer.layer.shadowOpacity = 0.8
        cellViewCOntainer.layer.shadowOffset = .zero
        cellViewCOntainer.layer.shadowRadius = 10
        cellViewCOntainer.layer.shadowPath = UIBezierPath(rect: cellViewCOntainer.bounds).cgPath
        cellViewCOntainer.layer.shouldRasterize = true
        cellViewCOntainer.layer.rasterizationScale = UIScreen.main.scale
        
    }

}
