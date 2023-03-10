//
//  RegisterProfileTalViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 30/01/23.
//

import UIKit

class RegisterProfileTalViewController: UIViewController {
    
    private let signUpViewModel = SignUpViewModel()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let appdel = UIApplication.shared.delegate as! AppDelegate
    var userProfile: UserProfile?
    var userPass = String()
    private var userCountry = String()
    private var userCity = String()
    private var userPhoneNum = String()
    private var userAbout = String()
    
    @IBOutlet weak var segmControl: UISegmentedControl!
    @IBOutlet weak var countryPricker: UIPickerView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        segmControl.selectedSegmentIndex = 2
        countryPricker.delegate = self
        countryPricker.dataSource = self
        cityTextField.delegate = self
        phoneNumTextField.delegate = self
        aboutTextField.delegate = self
        userCountry = Countries.countries.first!

    }
    
    private func bind() {
        self.signUpViewModel.signUpUiState = {
            DispatchQueue.main.async {
                if let isSaved = self.signUpViewModel.isSaved {
                    if isSaved {
                        // performar segue para ir a la pantalla principal (Jobs)
                        print("Registrado")
                        self.performSegue(withIdentifier: "toMainTal", sender: self)
                    }
                } else {
                    self.showAlert("Ha ocurrido un error. Intenta de nuevo más tarde")
                }
            }
        }
    }
    
    @IBAction func getCity(_ sender: Any) {
        if let text = cityTextField.text {
            if text.isEmpty {
                showAlert("Ingresa la ciudad donde resides")
            } else {
                userCity = text
            }
        }
    }
    
    @IBAction func getPhone(_ sender: Any) {
        if let text = phoneNumTextField.text {
            if text.isEmpty || text.count != 10 {
                showAlert("Ingresa un número de teléfono de 10 dígitos")
            } else {
                userPhoneNum = text
            }
        }
    }
    
    @IBAction func finishRegister(_ sender: Any) {
        if let errorMessage = checkFields() {
            showAlert(errorMessage)
        } else {
            userProfile?.country = userCountry
            userProfile?.city = userCity
            userProfile?.phoneNumber = userPhoneNum
            userProfile?.resume = aboutTextField.text
            if appdel.internetStatus{
                signUpViewModel.saveUserProfile(user: userProfile!, userPass: userPass, context: context)
                bind()
            } else {
                showNoInternet()
            }
        }
    }
    
    private func checkFields() -> String? {
        if userCountry.isEmpty {
            return "Por favor, selecciona un país"
        }
        if userCity.isEmpty {
            return "Por favor, ingresa tu ciudad de residencia"
        }
        if userPhoneNum.isEmpty {
            return "Por favor, ingresa un número de contacto de 10 dígitos"
        }
        return nil
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

extension RegisterProfileTalViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Countries.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Countries.countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userCountry = Countries.countries[row]
    }
}

extension RegisterProfileTalViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case cityTextField:
            self.phoneNumTextField.becomeFirstResponder()
        case phoneNumTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
}

extension RegisterProfileTalViewController {
    func showNoInternet() {
        let alertController = UIAlertController(title: "Ops!",
                                                message: "Lo sentimos, al parecer no hay conexión a internet. Para seguir utilizando la App se requiere una conexión",
                                                preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Enterado", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
