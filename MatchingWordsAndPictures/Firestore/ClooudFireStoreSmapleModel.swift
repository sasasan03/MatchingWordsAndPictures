//
//  TestModel.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/18.
//
import FirebaseFirestoreSwift
import Foundation

//MARK: - CloudFireStoreSampleViewで使用
struct Person: Codable {
    @DocumentID var id: String?
    let name: String
    let age: Int
    let favorite: [String]
    let isMarried: Bool

    enum CodingKeys: String, CodingKey {
        case name
        case age
        case favorite
        case isMarried = "Married"
    }
}

struct City: Codable{
    @DocumentID var id: String?
    var name: String
    var population: Int
    var specialProduct:[String]
}

//struct Person: Codable {
//    @DocumentID var id: String?
//    let name: String
//    let age: Int
//    let favorite: [String]
//    let isMarried: Bool
//}
