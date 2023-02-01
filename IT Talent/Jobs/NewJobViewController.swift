//
//  NewJobViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 31/01/23.
//

import UIKit

class NewJobViewController: UIViewController {
    
    @IBOutlet weak var chargeTextField: UITextField!
    @IBOutlet weak var enterpriseTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var vacanciesTextField: UITextField!
    @IBOutlet weak var wagePicker: UIPickerView!
    @IBOutlet weak var wageLabel: UILabel!
    @IBOutlet weak var modalPopUp: UIButton!
    @IBOutlet weak var typePopUp: UIButton!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let newJobViewModel = NewJobViewModel()
    
    private var wageText = "Selecciona el rango de salario aproximado: "
    private var wageRange = String()
    private var coin = String()
    private var charge = String()
    private var enterprise = String()
    private var location = String()
    private var vacancies = String()
    private var jobMode = String()
    private var jobType = String()
    private var jobTimestam = String()
    private var jobDate = String()
    private var jobTime = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initModalMenu()
        initTypeMenu()
        wagePicker.delegate = self
        wagePicker.dataSource = self
        wagePicker.selectRow(6, inComponent: 0, animated: true)
        wagePicker.selectRow(0, inComponent: 1, animated: true)
        wageRange = "\(Wages.wageRanges[6])"
        coin = "\(Wages.coins[0])"
        wageLabel.text = "\(wageText) \(wageRange) \(coin)"
        chargeTextField.delegate = self
        enterpriseTextField.delegate = self
        locationTextField.delegate = self
        vacanciesTextField.delegate = self
    }
    
    private func initModalMenu(){
        let optionModal = { (action: UIAction) in
            self.jobMode = action.title
        }
        
        modalPopUp.menu = UIMenu(children: [
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
        
        typePopUp.menu = UIMenu(children: [
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
    
    @IBAction func getCharge(_ sender: Any) {
        if let text = chargeTextField.text {
            if text.isEmpty {
                showAlert("Ingresa el nombre del puesto")
            } else {
                charge = text
            }
        }
    }
    
    @IBAction func getEnterprise(_ sender: Any) {
        if let text = enterpriseTextField.text {
            if text.isEmpty {
                showAlert("Ingresa la empresa o nombre del proyecto")
            } else {
                enterprise = text
            }
        }
    }
    
    @IBAction func getLocation(_ sender: Any) {
        if let text = locationTextField.text {
            if text.isEmpty {
                showAlert("Ingresa la ubicación del empleo, sin importar si es remoto")
            } else {
                location = text
            }
        }
    }
    
    @IBAction func getVacancies(_ sender: Any) {
        if let text = vacanciesTextField.text {
            if text.isEmpty {
                showAlert("Ingresa el número de vacantes disponibles para este puesto")
            } else {
                vacancies = text
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
    
    @IBAction func postJob(_ sender: Any) {
        if let errorMessage = checkFields() {
            showAlert(errorMessage)
        } else {
            let wageRange = "\(wageRange) \(coin)"
            getDateNTime()
            var newJob = Job(job: charge, enterprise: enterprise, imageUrl: "", location: location, mode: jobMode, type: jobType, wage: wageRange, vacancies: vacancies, applicants: [""], emailRecruiter: "", nameRecruiter: "", timestamp: jobTimestam, date: jobDate, time: jobTime, status: 0)
            
            newJobViewModel.saveNewJob(newJob: newJob, context: context)
            bind()
        }
    }
    
    private func getDateNTime() {
        jobTimestam = "\(Date())"
        let date = Date()
        jobDate = String("\(date)".split(separator: " ")[0])
        let hour = (Calendar.current.component(.hour, from: date))
        let minutes = (Calendar.current.component(.minute, from: date))
        let seconds = (Calendar.current.component(.second, from: date))
        jobTime = "\(hour):\(minutes):\(seconds)"
    }
    
    private func checkFields() -> String? {
        if charge.isEmpty {
            return "Ingresa el nombre del puesto"
        }
        if enterprise.isEmpty {
            return "Ingresa la empresa o nombre del proyecto"
        }
        if location.isEmpty {
            return "Ingresa la ubicación del empleo, sin importar si es remoto"
        }
        if vacancies.isEmpty {
            return "Ingresa el número de vacantes disponibles para este puesto"
        }
        return nil
    }
    
    private func bind() {
        self.newJobViewModel.newJobUiState = {
            DispatchQueue.main.async {
                if let isSaved = self.newJobViewModel.isSaved {
                    if isSaved {
                        // performar segue para ir a la pantalla principal (Jobs)
                        print("Main: Job guardado")
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.showAlert("Ha ocurrido un error. Intenta de nuevo más tarde")
                }
            }
        }
    }

}

extension NewJobViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return Wages.wageRanges.count
        } else {
            return Wages.coins.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return Wages.wageRanges[row]
        } else {
            return Wages.coins[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            wageRange = Wages.wageRanges[row]
            wageLabel.text = "\(wageText) \(wageRange) \(coin)"
        } else {
            coin = Wages.coins[row]
            wageLabel.text = "\(wageText) \(wageRange) \(coin)"
        }
    }
}

extension NewJobViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case chargeTextField:
            enterpriseTextField.becomeFirstResponder()
        case enterpriseTextField:
            locationTextField.becomeFirstResponder()
        case locationTextField:
            vacanciesTextField.becomeFirstResponder()
        case vacanciesTextField:
            vacanciesTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
