//
//  ViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 27/01/23.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var signInViewModel = SignInViewModel()
    private var userEmail = String()
    private var userPass = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Container correo y contraseña
        dataContainerView.layer.borderColor = Colors.disableColor.cgColor
        dataContainerView.layer.borderWidth = 1
        dataContainerView.layer.cornerRadius = 10
        dataContainerView.clipsToBounds = true
        
        inputEmail.delegate = self
        inputPassword.delegate = self
    }
    
    @IBAction func getEmail(_ sender: Any) {
        if let email = inputEmail.text {
            if let errorMessage = invalidEmail(email) {
                showAlert(errorMessage)
            } else {
                userEmail = email
            }
        }
    }
    
    private func invalidEmail(_ value: String)->  String? {
        let regularExp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExp)
        if !predicate.evaluate(with: value) {
            return "Ingresa un correo válido"
        }
        return nil
    }
    
    @IBAction func getPass(_ sender: Any) {
        if let pass = inputPassword.text {
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

    @IBAction func loginUser(_ sender: Any) {
        if userEmail.isEmpty && userPass.isEmpty {
            showAlert("Ingresa todas tus credenciales")
        } else {
            signInViewModel.signInUser(userEmail: userEmail, userPass: userPass, context: context)
            bind()
        }
    }
    
    private func bind(){
        signInViewModel.signInUiState = {
            DispatchQueue.main.async {
                if let userType = self.signInViewModel.userType {
                    switch userType {
                    case -2:
                        self.showAlert("Ocurrió un error guardando los datos")
                    case -1:
                        self.showAlert("Ocurrió un error obteniendo tu perfil, intenta iniciar sesión nuevamente más tarde")
                    case 0:
                        self.showAlert("Usuario no encontrado, parece ser que no te has registrado o las credenciales ingresadas son incorrectas")
                    case 1:
                        self.performSegue(withIdentifier: "toMainTal", sender: self)
                    case 2:
                        self.performSegue(withIdentifier: "toMainRec", sender: self)
                    default:
                        self.showAlert("Ocurrió un error indesperado")
                    }
                }
            }
        }
    }
    
    @IBAction func goToSignUp(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case inputEmail:
            inputPassword.becomeFirstResponder()
        case inputPassword:
            inputPassword.resignFirstResponder()
        default:
            return true
        }
        return true
    }
}
