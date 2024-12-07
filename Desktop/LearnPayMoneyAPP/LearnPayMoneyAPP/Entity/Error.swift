//
//  Error.swift
//  LearnPayMoneyAPP
//
//  Created by sako0602 on 2024/12/07.
//

import Foundation

enum ImageFileManagerError: LocalizedError {
    case documentURLNotFound
    case invalidFilePath
    case imageCreationFailed
    case dataConversionFailed
    case shopURLNotFound
    case goodsURLNotFound

    var errorDescription: String? {
        switch self {
        case .documentURLNotFound:
            return "ドキュメントURLが見つかりませんでした。"
        case .invalidFilePath:
            return "無効なファイルパスです。"
        case .imageCreationFailed:
            return "画像の作成に失敗しました。"
        case .dataConversionFailed:
            return "データの画像変換に失敗しました。"
        case .shopURLNotFound:
            return "shopのURLが見つかりませんでした。"
        case .goodsURLNotFound:
            return "goodsのURLが見つかりませんでした。"
        }
    }
}

enum ShopError: LocalizedError {
    case emptyShopName
    case saveDataError
    case matchingGoodError
    
    var errorDescription: String? {
        switch self {
        case .saveDataError:
            return "データの保存に失敗しました。"
        case .matchingGoodError:
            return "書き換えるグッズが見つけられませんでした。"
        case .emptyShopName:
            return "ショップネームを入力してください。"
        }
    }
}

enum GoodsError: LocalizedError {
    case emptyGoodsName
    case emptyGoodsPrice
    case invalidPrice
    
    var errorDescription: String? {
        switch self {
        case .emptyGoodsName:
            return "商品の名前を入力してください。"
        case .emptyGoodsPrice:
            return "商品の金額を入力してください。"
        case .invalidPrice:
            return "無効な金額です、"
        }
    }
}
