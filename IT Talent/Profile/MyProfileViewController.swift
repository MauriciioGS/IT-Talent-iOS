//
//  MyProfileViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 02/02/23.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var cityTextLabel: UITextField!

    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var containerEnterprise: UIView!
    @IBOutlet weak var enterpriseTextField: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var enableEdition: UISwitch!
    
    @IBOutlet weak var rolPicker: UIPickerView!
    
    @IBOutlet weak var rolLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var enterpriseLabel: UILabel!
    
    
    private let profileViewModel = ProfileViewModel()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var userProfile: UserProfile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileViewModel.getUser(context: context)
        bindGetUser()
        
        updateButton.isEnabled = false
    }
    
    private func bindGetUser() {
        profileViewModel.fetchUserProfile = {
            if let userFirebase = self.profileViewModel.userProfile {
                self.userProfile = userFirebase
                self.setUI()
            } else {
                self.showAlert("Ocurrió un error inesperado obteniendo tu perfil")
            }
        }
    }
    
    private func setUI() {
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.isHidden = true
        rolPicker.delegate = self
        rolPicker.dataSource = self
        rolPicker.isHidden = true
        
        nameTextField.delegate = self
        cityTextLabel.delegate = self
        phoneNumTextField.delegate = self
        
        
        nameTextField.text = userProfile?.fullName
        countryLabel.text = "País: \(userProfile!.country)"
        cityTextLabel.text = userProfile?.city
        phoneNumTextField.text = userProfile?.phoneNumber
        emailTextField.text = userProfile?.email
        aboutTextView.text = userProfile?.resume
        if let indexCountry = Countries.countries.firstIndex(of: userProfile!.country){
            countryPicker.selectRow(indexCountry, inComponent: 0, animated: true)
        }
        
        if userProfile!.userType == 1 {
            enterpriseLabel.text = "Rol profesional"
            enterpriseTextField.isHidden = true
            rolLabel.text = userProfile!.profRole
            if let indexRole = ProfRoles.arrayProfRoles.firstIndex(of: userProfile!.profRole) {
                rolPicker.selectRow(indexRole, inComponent: 0, animated: true)
            }
            
        } else {
            enterpriseTextField.delegate = self
            enterpriseTextField.isHidden = false
            enterpriseLabel.text = "Empresa"
            enterpriseTextField.text = userProfile?.enterprise
            rolLabel.text = "Rol que desempeñas: \(userProfile!.role)"
            if let indexRole = ProfRoles.roles.firstIndex(of: userProfile!.role) {
                rolPicker.selectRow(indexRole, inComponent: 0, animated: true)
            }
        }
        
    }
    
    @IBAction func enableEdit(_ sender: Any) {
        if enableEdition.isOn {
            updateButton.isEnabled = true
            enableTextFields()
        } else {
            updateButton.isEnabled = false
            disableEdit()
        }
    }
    
    private func enableTextFields() {
        nameTextField.isEnabled = true
        cityTextLabel.isEnabled =  true
        phoneNumTextField.isEnabled = true
        aboutTextView.isEditable = true
        enterpriseTextField.isEnabled = true
        
        countryPicker.isHidden = false
        rolPicker.isHidden = false

    }
    
    private func disableEdit() {
        nameTextField.isEnabled = false
        cityTextLabel.isEnabled =  false
        phoneNumTextField.isEnabled = false
        aboutTextView.isEditable = false
        enterpriseTextField.isEnabled = false
        
        countryPicker.isHidden = true
        rolPicker.isHidden = true
    }
    
    @IBAction func getName(_ sender: Any) {
        if let text = nameTextField.text {
            if text.isEmpty {
                showAlert("Ingresa tu nombre completo")
            } else {
                userProfile?.fullName = text
            }
        }
    }
    
    @IBAction func getCity(_ sender: Any) {
        if let text = cityTextLabel.text {
            if text.isEmpty {
                showAlert("Ingresa la ciudad dónde resides")
            } else {
                userProfile?.city = text
            }
        }
    }
    
    @IBAction func getPhoneNum(_ sender: Any) {
        if let text = phoneNumTextField.text {
            if text.isEmpty || text.count != 10 {
                showAlert("Ingresa un número de teléfono de 10 dígitos")
            } else {
                userProfile?.phoneNumber = text
            }
        }
    }
    
    @IBAction func getEnterprise(_ sender: Any) {
        if let text = enterpriseTextField.text {
            if text.isEmpty {
                showAlert("Ingresa la empresa para la que trabajas")
            } else {
                userProfile?.enterprise = text
            }
        }
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        if let error = checkFields() {
            showAlert(error)
        } else {
            userProfile!.resume = aboutTextView.text
            profileViewModel.updateUser(user: userProfile!)
            bindUserUpdate()
        }
    }
    
    private func bindUserUpdate() {
        profileViewModel.updateUserProfile = {
            if let isUpdated = self.profileViewModel.isUpdated {
                if isUpdated {
                    self.showAlertSuccess("Tu perfil se ha actualizado correctamente")
                    self.nameTextField.becomeFirstResponder()
                    self.disableEdit()
                } else {
                    self.showAlert("Ocurrió un error actualizando tu perfil, intenta de nuevo")
                }
            }
        }
    }
    
    @IBAction func deleteProfile(_ sender: Any) {
        // TODO: borrar perfil / quizá cerrar sesión
    }
    
}

extension MyProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case countryPicker:
            return Countries.countries.count
        case rolPicker:
            if userProfile!.userType == 1 {
                return ProfRoles.arrayProfRoles.count
            }
            return ProfRoles.roles.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case countryPicker:
            return Countries.countries[row]
        case rolPicker:
            if userProfile!.userType == 1 {
                return ProfRoles.arrayProfRoles[row]
            }
            return ProfRoles.roles[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case countryPicker:
            self.userProfile!.country = Countries.countries[row]
            countryLabel.text = "País: \(userProfile!.country)"
        case rolPicker:
            if userProfile!.userType == 1 {
                self.userProfile!.profRole = ProfRoles.arrayProfRoles[row]
                rolLabel.text = userProfile!.profRole
            } else {
                self.userProfile!.role = ProfRoles.roles[row]
                rolLabel.text = "Rol que desempeñas: \(userProfile!.role)"
            }
            
        default: break
        }
    }
    
    
    
}

extension MyProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            nameTextField.resignFirstResponder()
        case cityTextLabel:
            phoneNumTextField.becomeFirstResponder()
        case phoneNumTextField:
            aboutTextView.becomeFirstResponder()
        case aboutTextView:
            aboutTextView.resignFirstResponder()
        case enterpriseTextField:
            enterpriseTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

extension MyProfileViewController {
    
    func showAlert(_ errorMesssage: String) {
        // create the alert
        let alert = UIAlertController(title: "Ops!", message: errorMesssage, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSuccess(_ message: String) {
        // create the alert
        let alert = UIAlertController(title: "Perfil actualizado!", message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    private func checkFields() -> String? {
        if let text = nameTextField.text {
            if text.isEmpty {
                return "Ingresa tu nombre completo"
            }
        }
        if userProfile!.userType != 1 {
            if let text = enterpriseTextField.text {
                if text.isEmpty {
                    return "Ingresa la empresa para que colaboras"
                }
            }
        }
        if let text = cityTextLabel.text {
            if text.isEmpty {
                return "Ingresa tu ciudad"
            }
        }
        if let text = phoneNumTextField.text {
            if text.isEmpty {
                return "Ingresa un número de teléfono"
            }
        }
        return nil
    }
}
