//
//  FireStorageSampleModel.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/18.
//

import Foundation

struct userInfo: Identifiable, Codable{
    var id = UUID().uuidString
    let role: String
}


