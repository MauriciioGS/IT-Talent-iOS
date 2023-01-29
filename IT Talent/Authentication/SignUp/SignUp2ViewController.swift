//
//  SignUp2ViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 28/01/23.
//

import UIKit

class SignUp2ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var profRolePicker: UIPickerView!
    @IBOutlet weak var levelPicker: UIPickerView!
    
    private let signUpViewModel = SignUpViewModel()
    
    var userType = 0
    var userEmail = String()
    private var userFullName = String()
    private var profesionalRole = String()
    private var profesionalLevel = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        profRolePicker.dataSource = self
        profRolePicker.delegate = self
        levelPicker.dataSource = self
        levelPicker.delegate = self
        
        nameTextField.delegate = self
    }
    
    @IBAction func getFullName(_ sender: Any) {
        nameTextField.resignFirstResponder()
        if let text = nameTextField.text {
            if !text.isEmpty {
                userFullName = text
                welcomeText.text = "\(userFullName.split(separator: " ")[0]), ¿En qué rol te desenvuelves como profesional de TI?"
            }
        }
    }
    
    @IBAction func continueRegister(_ sender: Any) {
        signUpViewModel.saveProfesional(userType: userType, email: userEmail, name: userFullName, profRole: profesionalRole, profLevel: profesionalLevel)
        print(userFullName)
        print(userEmail)
        print(userType)
        print(profesionalRole)
        print(profesionalLevel)
    }
    
}

extension SignUp2ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == profRolePicker {
            return ProfRoles.arrayProfRoles.count
        }
        if pickerView == levelPicker {
            return ProfRoles.levels.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == profRolePicker {
            return ProfRoles.arrayProfRoles[row]
        }
        if pickerView == levelPicker {
            return ProfRoles.levels[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == profRolePicker {
            profesionalRole = ProfRoles.arrayProfRoles[row]
        }
        if pickerView == levelPicker {
            profesionalLevel = ProfRoles.levels[row]
        }
    }
    
}

extension SignUp2ViewController: UITextFieldDelegate {
    
    // Manda al siguiente TextField y al final oculta teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
