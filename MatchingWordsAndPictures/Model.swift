//
//  Model.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/06.
//

import Foundation

class Person: Hashable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.displayName == rhs.displayName && lhs.imageName == rhs.imageName && lhs.isTextChanged == rhs.isTextChanged
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(displayName)
        hasher.combine(imageName)
        hasher.combine(isTextChanged)
    }
    
    let displayName: String
    let imageName: String
    var isTextChanged: Bool
    init(displayName: String, imageName: String, isTextChanged: Bool) {
        self.displayName = displayName
        self.imageName = imageName
        self.isTextChanged = isTextChanged
    }
    
}

//struct Person: Hashable {
//    let displayName: String
//    let imageName: String
//    var isTextChanged: Bool
//}
