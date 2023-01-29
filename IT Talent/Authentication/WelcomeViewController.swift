//
//  WelcomeViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 28/01/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var userSegmControl: UISegmentedControl!
    @IBOutlet weak var viewCardContainer: UIView!
    @IBOutlet weak var imageUserType: UIImageView!
    @IBOutlet weak var textUserType: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnAlreadyRegistered: UIButton!
    
    private var userType = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Card
        viewCardContainer.backgroundColor = UIColor(named: "Background")!
        viewCardContainer.layer.cornerRadius = 10
        
        viewCardContainer.layer.shadowColor = UIColor.lightGray.cgColor
        viewCardContainer.layer.shadowOpacity = 0.8
        viewCardContainer.layer.shadowOffset = .zero
        viewCardContainer.layer.shadowRadius = 10
        viewCardContainer.layer.shadowPath = UIBezierPath(rect: viewCardContainer.bounds).cgPath
        viewCardContainer.layer.shouldRasterize = true
        viewCardContainer.layer.rasterizationScale = UIScreen.main.scale

    }
    

    @IBAction func typeUserChange(_ sender: Any) {
        userType = userSegmControl.selectedSegmentIndex + 1
        if userSegmControl.selectedSegmentIndex == 0 {
            imageUserType.image = UIImage(named: "TalentUserIcon")
            textUserType.text = "Soy talento en busca de oportunidades laborales y nuevos retos."
        } else {
            imageUserType.image = UIImage(named: "ReclutadorIcon")
            textUserType.text = "Busco el mejor talento para una empresa o proyecto."
        }
    }

    @IBAction func goToSignUp(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    @IBAction func goToSignIn(_ sender: Any) {
        performSegue(withIdentifier: "toSignIn", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp" {
            if let destino = segue.destination as? SignUp1ViewController {
                destino.userType = userType
            }
        }
    }
}
