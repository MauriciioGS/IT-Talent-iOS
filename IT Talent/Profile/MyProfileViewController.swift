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
    
    private let profileViewModel = ProfileViewModel()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var userProfile: UserProfile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileViewModel.getUser(context: context)
        bindGetUser()
        
        updateButton.isEnabled = false
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        rolPicker.delegate = self
        rolPicker.dataSource = self
    }
    
    private func bindGetUser() {
        profileViewModel.fetchUserProfile = {
            if let userFirebase = self.profileViewModel.userProfile {
                self.userProfile = userFirebase
                self.setUI()
            } else {
                
            }
        }
    }
    
    private func setUI() {
        nameTextField.delegate = self
        cityTextLabel.delegate = self
        phoneNumTextField.delegate = self
        enterpriseTextField.delegate = self
        
        nameTextField.text = userProfile?.fullName
        cityTextLabel.text = userProfile?.city
        phoneNumTextField.text = userProfile?.phoneNumber
        emailTextField.text = userProfile?.email
        aboutTextView.text = userProfile?.resume
        if let indexCountry = Countries.countries.firstIndex(of: userProfile!.country){
            countryPicker.selectRow(indexCountry, inComponent: 0, animated: true)
        }
        
        enterpriseTextField.text = userProfile?.enterprise
        if let indexRole = ProfRoles.roles.firstIndex(of: userProfile!.role) {
            rolPicker.selectRow(indexRole, inComponent: 0, animated: true)
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
    }
    
    private func disableEdit() {
        nameTextField.isEnabled = false
        cityTextLabel.isEnabled =  false
        phoneNumTextField.isEnabled = false
        aboutTextView.isEditable = false
        enterpriseTextField.isEnabled = false
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
    
    func showAlert(_ errorMesssage: String) {
        // create the alert
        let alert = UIAlertController(title: "Ops!", message: errorMesssage, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        print(userProfile)
    }
    
    @IBAction func deleteProfile(_ sender: Any) {
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
            return ProfRoles.roles[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case countryPicker:
            self.userProfile!.country = Countries.countries[row]
        case rolPicker:
            self.userProfile!.role = ProfRoles.roles[row]
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
