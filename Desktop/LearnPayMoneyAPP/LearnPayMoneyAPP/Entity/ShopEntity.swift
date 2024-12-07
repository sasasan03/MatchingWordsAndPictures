//
//  ShopEntity.swift
//  LearnPayMoneyAPP
//
//  Created by sako0602 on 2024/11/15.
//

import Foundation
import SwiftData

//お店
@Model
class Shop: Identifiable {
    var id = UUID()
    var name: String
    var imagePathURL: String?
    var goodsList: [Goods]
    
    init(name: String, imagePathURL: String? ,goods: [Goods]) {
        self.name = name
        self.imagePathURL = imagePathURL
        self.goodsList = goods
    }
}

//お店にある商品
@Model
class Goods: Identifiable {
    var id = UUID()
    var name: String
    var price: Int
    var imagePathURL: String?
    init(name: String, price: Int, imagePathURL: String?) {
        self.name = name
        self.price = price
        self.imagePathURL = imagePathURL
    }
}

