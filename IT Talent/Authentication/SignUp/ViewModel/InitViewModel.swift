//
//  InitViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 31/01/23.
//

import Foundation
import CoreData

class InitViewModel {
    
    private var mObjectContext: NSManagedObjectContext?
    
    var initUiState : (() -> ()) = { }
    
    var isSaved: Int? {
        didSet {
            initUiState()
        }
    }
    
    func getCredentials(_ context: NSManagedObjectContext) {
        
    }
}
