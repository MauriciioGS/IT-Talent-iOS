//
//  TalentViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 01/02/23.
//

import UIKit
import Lottie

class TalentViewController: UIViewController {
    
    @IBOutlet weak var animContainer: UIView!
    @IBOutlet weak var talentCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var profRoleLabel: UILabel!
    
    
    let talentViewModel = TalentViewModel()
    
    private var noDataAnimation: LottieAnimationView?
    private var cellTalentWidth: CGFloat?
    var talentList: [UserProfile] = []
    var talentFilteredList: [UserProfile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noDataAnimation = .init(name: "no_data")
        noDataAnimation!.frame = self.animContainer.bounds
        noDataAnimation!.contentMode = .scaleAspectFit
        noDataAnimation!.loopMode = .loop
        noDataAnimation!.animationSpeed = 0.5
        animContainer.addSubview(self.noDataAnimation!)
        animContainer.isHidden = true
        
        talentViewModel.getAllTalent()
        bindAllTalent()
        
        searchBar.delegate = self
        
        talentCollectionView.delegate = self
        talentCollectionView.dataSource = self
        talentCollectionView.register(UINib(nibName: "TalentViewCell", bundle: nil), forCellWithReuseIdentifier: "talentCell")
        cellTalentWidth = talentCollectionView.bounds.width - (talentCollectionView.bounds.width / 2)
    }
    
    private func bindAllTalent() {
        talentViewModel.fetchTalent = {
            DispatchQueue.main.async {
                if let talent = self.talentViewModel.talentList {
                    if talent.isEmpty {
                        self.animContainer.isHidden = false
                        self.noDataAnimation!.play()
                    } else {
                        self.animContainer.isHidden = true
                        self.talentList = talent
                        print(self.talentList)
                        self.talentCollectionView.reloadData()
                    }
                }
                
            }
        }
    }
    
    @IBAction func getAllTalent(_ sender: Any) {
        talentViewModel.getAllTalent()
    }
    

}

extension TalentViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let filter = searchBar.text {
            profRoleLabel.text = filter
            filterForSearchText(searchText: filter)
        }
    }
    
    func filterForSearchText(searchText: String) {
        if !searchText.isEmpty {
            talentList.forEach { talent in
                if (talent.profRole.lowercased() == searchText.lowercased() || talent.profRole.lowercased().contains(searchText.lowercased())) {
                    talentFilteredList.append(talent)
                }
            }
            talentList = talentFilteredList
            talentCollectionView.reloadData()
        }
    }
    
}

extension TalentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return talentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let talentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "talentCell", for: indexPath) as? TalentViewCell
        let talent = talentList[indexPath.row]
        talentCell!.nameLabel.text = talent.fullName
        talentCell!.profRoleLabel.text = talent.profRole
        talentCell!.locationLabel.text = "\(talent.city), \(talent.country)"
        var yearsXP = 0
        talent.experiences.forEach { xp in
            yearsXP += xp.yearsXp
        }
        talentCell!.yearsLabel.text = "\(yearsXP) años de experiencia"
        return talentCell!
    }
    
}

extension TalentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellTalentWidth!, height: 100)
    }
}
