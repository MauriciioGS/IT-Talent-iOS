//
//  ExperiencesViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 30/01/23.
//

import UIKit

class ExperiencesViewController: UIViewController {
    
    @IBOutlet weak var segmControl: UISegmentedControl!
    @IBOutlet weak var chargeTextField: UITextField!
    @IBOutlet weak var enterpriseTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var logrosTextView: UITextView!
    @IBOutlet weak var modalButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var monthInButton: UIButton!
    @IBOutlet weak var monthEndButton: UIButton!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var yearEndTextField: UITextField!
    @IBOutlet weak var typeBtn: UIButton!
    
    
    var userProfile: UserProfile?
    private var jobMode = String()
    private var job = String()
    private var enterprise = String()
    private var jobCountry = String()
    private var jobAchievements = String()
    private var jobType = String()
    private var jobMonthIn = String()
    private var jobYearIn = String()
    private var jobMonthEnd = String()
    private var jobYearEnd = String()
    private var nowadays = Bool()
    private var experience: Experience?

    override func viewDidLoad() {
        super.viewDidLoad()

        segmControl.selectedSegmentIndex = 1
        
        chargeTextField.delegate = self
        enterpriseTextField.delegate = self
        countryTextField.delegate = self
        
        initModalMenu()
        initTypeMenu()
        initMontInMenu()
        initMontEndMenu()
        
    }
    
    private func initModalMenu(){
        let optionModal = { (action: UIAction) in
            self.jobMode = action.title
        }
        
        modalButton.menu = UIMenu(children: [
            UIAction(title: "Presencial", state: .on, handler: optionModal),
            UIAction(title: "Híbrido", handler: optionModal),
            UIAction(title: "Remoto", handler: optionModal)
        ])
    }
    
    private func initTypeMenu() {
        let optionType = { (action: UIAction) in
            self.jobType = action.title
        }
        
        typeBtn.menu = UIMenu(children: [
            UIAction(title: "Tiempo Completo", state: .on, handler: optionType),
            UIAction(title: "Medio Tiempo", handler: optionType),
            UIAction(title: "Freelance", handler: optionType),
            UIAction(title: "Prácticas", handler: optionType),
            UIAction(title: "Formación", handler: optionType),
            UIAction(title: "Temporal", handler: optionType),
            UIAction(title: "Becario/Trainee", handler: optionType)
        ])
    }
    
    private func initMontInMenu() {
        let optionMonth = { (action: UIAction) in
            self.jobMonthIn = action.title
        }
        
        monthInButton.menu = UIMenu(children: [
            UIAction(title: "Enero", state: .on, handler: optionMonth),
            UIAction(title: "Febrero", handler: optionMonth),
            UIAction(title: "Marzo", handler: optionMonth),
            UIAction(title: "Abril", handler: optionMonth),
            UIAction(title: "Mayo", handler: optionMonth),
            UIAction(title: "Junio", handler: optionMonth),
            UIAction(title: "Julio", handler: optionMonth),
            UIAction(title: "Agosto", handler: optionMonth),
            UIAction(title: "Septiembre", handler: optionMonth),
            UIAction(title: "Octubre", handler: optionMonth),
            UIAction(title: "Noviembre", handler: optionMonth),
            UIAction(title: "Diciembre", handler: optionMonth),
            
        ])
    }
    
    private func initMontEndMenu() {
        let optionMonth = { (action: UIAction) in
            self.jobMonthEnd = action.title
        }
        
        monthEndButton.menu = UIMenu(children: [
            UIAction(title: "Enero", state: .on, handler: optionMonth),
            UIAction(title: "Febrero", handler: optionMonth),
            UIAction(title: "Marzo", handler: optionMonth),
            UIAction(title: "Abril", handler: optionMonth),
            UIAction(title: "Mayo", handler: optionMonth),
            UIAction(title: "Junio", handler: optionMonth),
            UIAction(title: "Julio", handler: optionMonth),
            UIAction(title: "Agosto", handler: optionMonth),
            UIAction(title: "Septiembre", handler: optionMonth),
            UIAction(title: "Octubre", handler: optionMonth),
            UIAction(title: "Noviembre", handler: optionMonth),
            UIAction(title: "Diciembre", handler: optionMonth),
            
        ])
    }
    
    @IBAction func endYearInEdit(_ sender: Any) {
        if let text = yearTextField.text {
            if text.count == 4 {
                self.jobYearIn = text
            } else {
                showAlert("Ingresa una fecha válida")
            }
        }
    }
    
    @IBAction func endYearEdit(_ sender: Any) {
        if let text = yearEndTextField.text {
            if text.count == 4 {
                self.jobYearEnd = text
            } else {
                showAlert("Ingresa una fecha válida")
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
    
}

extension ExperiencesViewController: UITextFieldDelegate {
    
    // Manda al siguiente TextField y al final oculta teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case enterpriseTextField:
            self.countryTextField.becomeFirstResponder()
        case chargeTextField:
            self.enterpriseTextField.becomeFirstResponder()
        case countryTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
