//
//  RegisterEnterpriseViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 29/01/23.
//

import UIKit

class RegisterEnterpriseViewController: UIViewController {
    
    @IBOutlet weak var enterpriseTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    var userProfile: UserProfile?
    private var userEnterprise = String()
    private var userRole = String()
    
    private let signUpViewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        enterpriseTextField.delegate = self
        roleTextField.delegate = self
        
    }
    
    @IBAction func getEnterprise(_ sender: Any) {
        if let enterprise = enterpriseTextField.text {
            if enterprise.isEmpty {
                showAlert("Por favor, introduce la empresa para la que estás reclutando")
            } else {
                userEnterprise = enterprise
            }
        }
    }
    
    @IBAction func getRole(_ sender: Any) {
        if let role = roleTextField.text {
            if role.isEmpty {
                showAlert("Por favor, introduce el rol que desempeñas en dicha empresa")
            } else {
                userRole = role
            }
        }
    }
    
    @IBAction func signInRecruiter(_ sender: Any) {
        print(userEnterprise)
        print(userRole)
        userProfile?.enterprise = userEnterprise
        userProfile?.role = userRole
        signUpViewModel.saveUserProfile(user: userProfile!)
        bind()
    }
    
    private func bind() {
        self.signUpViewModel.signUpUiState = {
            DispatchQueue.main.async {
                if let _ = self.signUpViewModel.isSaved {
                    // performar segue para ir a la pantalla principal (Jobs)
                    self.showAlert("Registrado!")
                } else {
                    self.showAlert("Ha ocurrido un error. Intenta de nuevo más tarde")
                }
            }
        }
    }
    
    @IBAction func registerEnterprise(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "Nueva empresa", message: "Para registrar una empresa, envíanos un correo con la información fiscal e imágen a utilizar dentro de la aplicación: mauricaz@outlook.com", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showAlert(_ errorMesssage: String) {
        // create the alert
        let alert = UIAlertController(title: "Ops!", message: errorMesssage, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension RegisterEnterpriseViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case enterpriseTextField:
            self.roleTextField.becomeFirstResponder()
        case roleTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
