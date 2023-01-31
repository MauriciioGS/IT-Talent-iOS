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
    var userPass = String()
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
    private var experiences: [Experience] = []

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
        jobMode = "Presencial"
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
        jobType = "Tiempo Completo"
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
        jobMonthIn = "Enero"
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
        jobMonthEnd = "Enero"
    }
    
    @IBAction func getJob(_ sender: Any) {
        if let text = chargeTextField.text {
            if text.isEmpty {
                showAlert("Ingresa un cargo")
            } else {
                job = text
            }
        }
    }
    
    @IBAction func getEnterprise(_ sender: Any) {
        if let text = enterpriseTextField.text {
            if text.isEmpty {
                showAlert("Ingresa la empresa en la que trabajaste")
            } else {
                enterprise = text
            }
        }
    }
    
    @IBAction func getCountry(_ sender: Any) {
        if let text = countryTextField.text {
            if text.isEmpty {
                showAlert("Ingresa el país, ciudad, región donde trabajaste. En caso de trabajar remoto desde donde lo hiciste")
            } else {
                jobCountry = text
            }
        }
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
    
    @IBAction func continueRegister(_ sender: Any) {
        self.textFieldShouldReturn(yearTextField)
        self.textFieldShouldReturn(yearEndTextField)
        jobAchievements = logrosTextView.text
        if !correctFields() {
            showAlert("Rellena todos los campos")
        } else {
            let jobPeriod = "\(jobMonthIn) \(jobYearIn) - \(jobMonthEnd) \(jobYearEnd)"
            let jobYears = DateTime().getYearsBetweenTwoDates(montI: jobMonthIn, yearI: jobYearIn, montF: jobMonthEnd, yearF: jobYearEnd)
            let newExperience = Experience(charge: job, enterprise: enterprise, city: jobCountry, mode: jobMode, type: jobType, period: jobPeriod, yearsXp: jobYears, achievements: jobAchievements)
            experiences.append(newExperience)
            userProfile?.experiences = experiences
            showSuccessfull()
        }
    }
    
    func correctFields() -> Bool {
        if job.isEmpty {
            showAlert("Ingresa un cargo")
            return false
        }
        if enterprise.isEmpty {
            showAlert("Ingresa la empresa en la que trabajaste")
            return false
        }
        if jobCountry.isEmpty {
            showAlert("Ingresa el país, ciudad, región donde trabajaste. En caso de trabajar remoto desde donde lo hiciste")
            return false
        }
        if jobAchievements.isEmpty {
            showAlert("Ingresa tus logros, experiencias, retos, aprendizajes")
            return false
        }
        if jobMode.isEmpty || jobType.isEmpty {
            return false
        }
        if jobMonthEnd.isEmpty || jobYearEnd.isEmpty {
            return false
        }
        if jobMonthIn.isEmpty || jobYearIn.isEmpty {
            return false
        }
        return true
    }
    
    private func showSuccessfull() {
        // create the alert
        let alert = UIAlertController(title: "Experiencia guardada", message: "¿Deseas registrar otra experiencia laboral?", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: { action in
            self.resetForm()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { action in
            self.performSegue(withIdentifier: "toProfileReg", sender: self)
        }))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    private func resetForm() {
        chargeTextField.becomeFirstResponder()
        chargeTextField.text = ""
        countryTextField.text = ""
        enterpriseTextField.text = ""
        yearTextField.text = ""
        yearEndTextField.text = ""
        logrosTextView.text = ""
    }
    
    private func showAlert(_ errorMesssage: String) {
        // create the alert
        let alert = UIAlertController(title: "Ops!", message: errorMesssage, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? RegisterProfileTalViewController {
            destino.userProfile = userProfile
            destino.userPass = userPass
        }
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
        case yearTextField:
            textField.resignFirstResponder()
        case yearEndTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
