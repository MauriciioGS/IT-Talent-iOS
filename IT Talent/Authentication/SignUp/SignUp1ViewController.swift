//
//  SignUp1ViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 28/01/23.
//

import UIKit
import FirebaseAuth

class SignUp1ViewController: UIViewController {
    
    var userType: Int = 0
    @IBOutlet weak var formContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!

    private var userEmail = String()
    private var userPass = String()
    private let appdel = UIApplication.shared.delegate as! AppDelegate

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
    
    @IBAction func signUpUser(_ sender: Any) {
        if appdel.internetStatus {
            Auth.auth().createUser(withEmail: userEmail, password: userPass) { (result, error) in
                if let _ = result, error == nil {
                    if self.userType == 1 {
                        self.performSegue(withIdentifier: "toRegisterTal", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "toRegisterRec", sender: self)
                    }
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error al registrar", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            showNoInternet()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? SignUp2ViewController {
            destino.userEmail = userEmail
            destino.userType = userType
            destino.userPass = userPass
            destino.title = "¡Bienvenido Talento!"
        }
        if let destino = segue.destination as? RegisterProfileRecViewController {
            destino.userEmail = userEmail
            destino.userType = userType
            destino.userPass = userPass
            destino.title = "¡Bienvenido Reclutador!"
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

extension SignUp1ViewController {
    func showNoInternet() {
        let alertController = UIAlertController(title: "Ops!",
                                                message: "Lo sentimos, al parecer no hay conexión a internet. Para seguir utilizando la App se requiere una conexión",
                                                preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Enterado", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
