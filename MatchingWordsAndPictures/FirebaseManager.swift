//
//  FirebaseManager.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/23.
//

import Foundation
import SwiftUI
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
    
    func fetchpPictureData(completion: @escaping (UIImage?) -> Void){
        let storageRef = storage.reference(forURL: "gs://matchingwordsandpictures.appspot.com").child("enel.png")
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("🍔Error downloading imgage: \(error)")
                completion(nil)
            } else if let data = data {
                completion(UIImage(data: data))
            }
        }
    }
    
}
