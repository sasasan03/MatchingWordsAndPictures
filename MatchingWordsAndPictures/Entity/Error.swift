//
//  Error.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/29.
//

import Foundation

enum FirebaseError: Error {
    case uploadError
    case downloadError
    case uidError
    case getImageError
    var errorType: String {
        switch self {
        case .uploadError:
            return "アップロードできませんでした"
        case .downloadError:
            return "ダウンロードできませんでした"
        case .uidError:
            return "uidを取得できませんでした"
        case .getImageError:
            return "画像の取得に失敗"
        }
    }
}
