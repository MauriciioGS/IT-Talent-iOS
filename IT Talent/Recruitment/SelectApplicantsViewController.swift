//
//  SelectApplicantsViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 05/02/23.
//

import UIKit
import Lottie

class SelectApplicantsViewController: UIViewController {
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var applicantsCollectionView: UICollectionView!
    @IBOutlet weak var animContainerView: UIView!
    
    private var noDataAnim: LottieAnimationView?
    private var loadingAnim: LottieAnimationView?
    private let selectApplicantsViewModel = SelectApplicantsViewModel()
    private var cellWidth: CGFloat?
    
    var jobSelected: Job?
    var listOfApplicants: [UserProfile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectApplicantsViewModel.getAppplicantsByJob(jobSelected!.applicants)

        applicantsCollectionView.allowsMultipleSelection = true
        applicantsCollectionView.register(UINib(nibName: "ApplicantViewCell", bundle: nil), forCellWithReuseIdentifier: "applicantCell")
        applicantsCollectionView.dataSource = self
        applicantsCollectionView.delegate = self
        applicantsCollectionView.isHidden = true
        
        cellWidth = applicantsCollectionView.bounds.width - (applicantsCollectionView.bounds.width / 8)
        
        noDataAnim = .init(name: "no_data")
        noDataAnim!.frame = animContainerView.bounds
        noDataAnim!.contentMode = .scaleAspectFit
        noDataAnim!.loopMode = .loop
        noDataAnim!.animationSpeed = 0.5
        animContainerView.addSubview(noDataAnim!)
        noDataAnim!.play()
        noDataAnim!.isHidden = true
        
        loadingAnim = .init(name: "loading_anim")
        loadingAnim!.frame = animContainerView.bounds
        loadingAnim!.contentMode = .scaleAspectFit
        loadingAnim!.loopMode = .loop
        loadingAnim!.animationSpeed = 0.5
        animContainerView.addSubview(loadingAnim!)
        loadingAnim!.play()
        loadingAnim!.isHidden = false
        
        animContainerView.isHidden = false
        
        bind()
    }
    
    private func bind() {
        selectApplicantsViewModel.fetchApplicants = {
            DispatchQueue.main.async {
                if let applicants = self.selectApplicantsViewModel.applicantsList {
                    if applicants.isEmpty {
                        self.noDataAnim!.isHidden = false
                        self.loadingAnim!.isHidden = true
                        print("Lista vacia")
                    } else {
                        self.listOfApplicants = applicants
                        self.loadingAnim!.isHidden = true
                        self.animContainerView.isHidden = true
                        self.applicantsCollectionView.isHidden = false
                        self.applicantsCollectionView.reloadData()
                        print(self.listOfApplicants)
                    }
                } else {
                    print("Aqui")
                }
            }
        }
    }

    @IBAction func toNextStage(_ sender: Any) {
    }
    

}

extension SelectApplicantsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfApplicants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "applicantCell", for: indexPath) as? ApplicantViewCell
        let applicant = listOfApplicants[indexPath.row]
        
        cell!.userName.text = applicant.fullName
        cell!.profRoleLabel.text = applicant.profRole
        cell!.locationLabel.text = "\(applicant.city), \(applicant.country)"
        var yearsXP = 0
        applicant.experiences.forEach { xp in
            yearsXP += xp.yearsXp
        }
        cell!.expYearsLabel.text = "\(yearsXP)"
        return cell!
    }
    
}

extension SelectApplicantsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth!, height: 128.0)
    }
}
