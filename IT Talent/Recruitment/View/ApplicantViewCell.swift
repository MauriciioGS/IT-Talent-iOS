//
//  ApplicantViewCell.swift
//  IT Talent
//
//  Created by Mauricio García S on 05/02/23.
//

import UIKit

class ApplicantViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profRoleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var expYearsLabel: UILabel!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var selectedIndicatorView: UIView!
    
    override var isHighlighted: Bool {
        didSet {
            selectedIndicatorView.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            selectedIndicatorView.isHidden = !isSelected
            actionImageView.isHidden = !isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
