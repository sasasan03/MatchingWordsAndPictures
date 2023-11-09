//
//  SignupAndLogin.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/11/05.
//

import Foundation

//MARK: - SignInに使用するエラー


//MARK: - Login時に使用するエラー

public enum AuthError: LocalizedError {
    // ネットワークエラー
    case networkError
    // パスワードが条件より脆弱であることを示します。
    case weakPassword
    // ユーザーが間違ったパスワードでログインしようとしたことを示します。
    case wrongPassword
    // ユーザーのアカウントが無効になっていることを示します。
    case userNotFound
    // メールアドレスの形式が正しくないことを示します。
    case invalidEmail
    // 既に登録されているメールアドレス
    case emailAlreadyInUse
    // その他のエラー
    case other

    /// エラーによって表示する文字を定義
    var title: String? {
        switch self {
            case .networkError:
                return "通信エラーです。"
            case .weakPassword:
                return "パスワードが脆弱です。"
            case .wrongPassword:
                return "メールアドレス、もしくはパスワードが違います。"
            case .userNotFound:
                return "アカウントがありません。"
            case .invalidEmail:
                return "正しくないメールアドレスの形式です。"
            case .emailAlreadyInUse:
                return "既に登録されているメールアドレスです。"
            case .other:
                return "原因不明のエラー。サーバーサイドかな？"
        }
    }
}

/// Firestoreに関するエラー
public enum FirestoreError: Error {

    // 操作はキャンセルされました
    case cancelled
    // 不明なエラー
    case unknown
    // クライアントが無効な引数を指定しました。
    case invalidArgument
    // 操作が完了する前に期限が切れました。
    case deadlineExceeded
    // 要求されたドキュメントが見つかりませんでした。
    case notFound
    // 作成しようとしたドキュメントはすでに存在します
    case alreadyExists
    // 指定された操作を実行する権限がありません。
    case permissionDenied
    // 容量が不足している可能性があります。
    case resourceExhausted
    // システムが操作の実行に必要な状態にないため、操作は拒否されました。
    case failedPrecondition
    // 同時実行の問題が原因で、操作が中止されました。
    case aborted
    // 有効範囲を超えて操作を試みました。
    case outOfRange
    // サポート/有効化されていません。
    case unimplemented
    // 内部エラー。
    case `internal`
    // このサービスは現在ご利用いただけません。
    case unavailable
    // 回復不能なデータの損失または破損。
    case dataLoss
    // 操作の有効な認証クレデンシャルがありません。
    case unauthenticated

    //エラーによって表示する文字を定義
    var title: String {
        switch self {

            case .cancelled:
                return "操作はキャンセルされました"
            case .unknown:
                return "不明なエラー"
            case .invalidArgument:
                return "クライアントが無効な引数を指定しました。"
            case .deadlineExceeded:
                return "操作が完了する前に期限が切れました。"
            case .notFound:
                return "要求されたドキュメントが見つかりませんでした。"
            case .alreadyExists:
                return "作成しようとしたドキュメントはすでに存在します"
            case .permissionDenied:
                return "指定された操作を実行する権限がありません。"
            case .resourceExhausted:
                return "容量が不足している可能性があります。"
            case .failedPrecondition:
                return "システムが操作の実行に必要な状態にないため、操作は拒否されました。"
            case .aborted:
                return "同時実行の問題が原因で、操作が中止されました。"
            case .outOfRange:
                return "有効範囲を超えて操作を試みました。"
            case .unimplemented:
                return "サポート/有効化されていません。"
            case .internal:
                return "内部エラー。"
            case .unavailable:
                return "このサービスは現在ご利用いただけません。"
            case .dataLoss:
                return "回復不能なデータの損失または破損。"
            case .unauthenticated:
                return "操作の有効な認証クレデンシャルがありません。"
        }
    }
}
