//
//  SignUp1ViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 28/01/23.
//

import UIKit

class SignUp1ViewController: UIViewController {
    
    var userType: Int = 0
    @IBOutlet weak var formContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!

    private var userEmail = String()
    private var userPass = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(userType)
        // Container correo y contraseña
        formContainerView.layer.borderColor = Colors.disableColor.cgColor
        formContainerView.layer.borderWidth = 1
        formContainerView.layer.cornerRadius = 10
        formContainerView.clipsToBounds = true
        // Inhabilitar boton de continuar
        continueButton.isEnabled = false
        
        emailTextField.delegate = self
        passTextField.delegate = self
        confirmPassTextField.delegate = self
        
    }
    
    @IBAction func emailEndEdit(_ sender: Any) {
        if let email = emailTextField.text {
            if let errorMessage = invalidEmail(email) {
                showAlert(errorMessage)
            } else {
                userEmail = email
            }
        }
    }
    
    func invalidEmail(_ value: String)->  String? {
        let regularExp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExp)
        if !predicate.evaluate(with: value) {
            return "Ingresa un correo válido"
        }
        return nil
    }
    
    @IBAction func passwordEndEdit(_ sender: Any) {
        if let pass = passTextField.text {
            if let errorMessage = invalidPass(pass) {
                showAlert(errorMessage)
            } else {
                userPass = pass
            }
        }
    }
    
    func invalidPass(_ value: String) -> String? {
        if value.count < 6 && !value.isEmpty {
            return "Ingresa una constraseña de al menos 6 caracteres"
        }
        return nil
    }
    
    @IBAction func confirmPassword(_ sender: Any) {
        if let pass = confirmPassTextField.text {
            if pass != userPass {
                showAlert("Las constraseñas no coinciden")
            } else {
                continueButton.isEnabled = true
            }
        }
    }
    
    func showAlert(_ errorMesssage: String) {
        // create the alert
        let alert = UIAlertController(title: "Ops!", message: errorMesssage, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpUser(_ sender: Any) {
        
    }

}

extension SignUp1ViewController: UITextFieldDelegate {
    
    // Manda al siguiente TextField y al final oculta teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            textField.resignFirstResponder()
        }
        if textField == self.passTextField {
            self.confirmPassTextField.becomeFirstResponder()
        }
        if textField == self.confirmPassTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
