//
//  SignupAndLogin.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/11/05.
//

import Foundation

//MARK: - Login時に使用するエラー

enum LoginValidationError: LocalizedError {
    case emailError
    case passwordError
    case unknown
    
    var errorDescription: String?{
        switch self {
        case .emailError: return "emailの形式が間違っています"
        case .passwordError: return "パスワードが間違っています"
        case .unknown: return "原因不明"
        }
    }
}
