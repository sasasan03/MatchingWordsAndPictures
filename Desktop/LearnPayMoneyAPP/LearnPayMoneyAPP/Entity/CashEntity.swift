//
//  CashEntity.swift
//  LearnPayMoneyAPP
//
//  Created by sako0602 on 2024/12/07.
//

import Foundation

struct CashItem: Identifiable {
    let id = UUID()
    let imageName: String
    var location: CGPoint = .zero
    let startPositionWidth: Double
    let startPositionHeight: Double
    var isInTray = false
    let cashValue: Int
    
    func makeBackGroundItem() -> [CashItem] {
        return (0 ..< 10).map { _ in
            CashItem(imageName: imageName,
                     startPositionWidth: startPositionWidth,
                     startPositionHeight: startPositionHeight,
                     cashValue: cashValue
            )
        }
    }
}
