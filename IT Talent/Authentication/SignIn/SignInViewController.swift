//
//  ViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 27/01/23.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    private let disableColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataContainerView.layer.borderColor = disableColor.cgColor
        dataContainerView.layer.borderWidth = 1
        dataContainerView.layer.cornerRadius = 10
        dataContainerView.clipsToBounds = true
        
    }


}

