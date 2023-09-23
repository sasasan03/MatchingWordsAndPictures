//
//  FirebaseManager.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/23.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    
    static let shared = FirebaseManager()
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        super.init()
    }
}
