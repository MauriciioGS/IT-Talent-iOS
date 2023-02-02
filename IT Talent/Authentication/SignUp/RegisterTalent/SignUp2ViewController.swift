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
    
    var userType = 0
    var userEmail = String()
    var userPass = String()
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
    
    override func viewWillAppear(_ animated: Bool) {
        profesionalRole = ProfRoles.arrayProfRoles[profRolePicker.selectedRow(inComponent: 0)]
        print(profesionalRole)
        profesionalLevel = ProfRoles.levels[levelPicker.selectedRow(inComponent: 0)]
        print(profesionalLevel)
    }
    
    @IBAction func getFullName(_ sender: Any) {
        nameTextField.resignFirstResponder()
        if let text = nameTextField.text {
            if !text.isEmpty {
                userFullName = text
                welcomeText.text = "\(userFullName.split(separator: " ")[0]), ¿En qué rol te desenvuelves como profesional de TI?"
            } else {
                showAlert("Por favor, ingresa tu nombre completo")
            }
        }
    }
    
    @IBAction func continueRegister(_ sender: Any) {
        if (!userFullName.isEmpty) {
            self.performSegue(withIdentifier: "toSkills", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? SkillsViewController {
            // Crea usuario y pasarlo entre las siguientes pantallas
            let userProfile = UserProfile(userType: userType, email: userEmail, fullName: userFullName, country: "", city: "", phoneNumber: "", resume: "", profRole: profesionalRole, xpLevel: profesionalLevel, skills: [""], enterprise: "", role: "")
            destino.userProfile = userProfile
            destino.userPass = userPass
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
