//
//  RegisterProfileRecViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 28/01/23.
//

import UIKit

class RegisterProfileRecViewController: UIViewController {
    
    var userType = 0
    var userEmail = String()
    private var userFullName = String()
    private var userCountry = String()
    private var userCity = String()
    private var userPhoneNum = String()
    private var aboutUser = String()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextView!
    @IBOutlet weak var continueButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        countryPicker.delegate = self
        countryPicker.dataSource = self
        nameTextField.delegate = self
        cityTextField.delegate = self
        numberTextField.delegate = self
        aboutTextField.delegate = self
        
        userCountry = Countries.countries.first!
    }
    
    @IBAction func getFullName(_ sender: Any) {
        if let text = nameTextField.text {
            if !text.isEmpty {
                userFullName = text
            } else {
                showAlert("Por favor, ingresa tu nombre completo")
            }
        } else {
            showAlert("Por favor, ingresa tu nombre completo")
        }
    }
    
    @IBAction func getCity(_ sender: Any) {
        if let text = cityTextField.text {
            if !text.isEmpty {
                userCity = text
            } else {
                showAlert("Por favor, ingresa la ciudad donde resides")
            }
        } else {
            showAlert("Por favor, ingresa la ciudad donde resides")
        }
    }
    
    @IBAction func getPhoneNum(_ sender: Any) {
        if let text = numberTextField.text {
            print(text.count)
            if !text.isEmpty && text.count == 10{
                userPhoneNum = text
            } else {
                showAlert("Ingresa un número telefónico de 10 dígitos")
            }
        } else {
            showAlert("Por favor, tu número de contacto")
        }
    }
    
    @IBAction func continueRegister(_ sender: Any) {
            if let errorMessage = checkFields() {
                showAlert(errorMessage)
            } else {
                self.performSegue(withIdentifier: "toRegEnterprise", sender: self)
            }
    }
    
    private func checkFields() -> String? {
        if userFullName.isEmpty {
            return "Por favor, ingresa tu nombre completo"
        }
        if userCountry.isEmpty {
            return "Por favor, selecciona un país"
        }
        if userCity.isEmpty {
            return "Por favor, ingresa tu ciudad de residencia"
        }
        if userPhoneNum.isEmpty {
            return "Por favor, ingresa un número de contacto de 10 dígitos"
        }
        if aboutUser.isEmpty {
            return "Por favor, ingresa un resumen de tí"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? RegisterEnterpriseViewController {
            destino.userProfile = UserProfile(userType: userType, email: userEmail, fullName: userFullName, country: userCountry, city: userCity, phoneNumber: userPhoneNum, resume: aboutUser, profRole: "", xpLevel: "", skills: [""], enterprise: "", role: "")
            destino.title = "Empresa"
        }
    }
    
}

extension RegisterProfileRecViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension RegisterProfileRecViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            textField.resignFirstResponder()
        case cityTextField:
            self.numberTextField.becomeFirstResponder()
        case aboutTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
}
