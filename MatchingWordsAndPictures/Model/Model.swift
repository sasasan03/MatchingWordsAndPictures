//
//  Model.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/06.
//

import Foundation
import UIKit

struct PersonDomeinObject: Hashable {
    let displayName: String
    let imageName: String
    var isTextChanged: Bool
}


class Person2: Hashable {
    static func == (lhs: Person2, rhs: Person2) -> Bool {
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

//
struct ImageText {
    var text: String = ""
    var image: UIImage?
}
