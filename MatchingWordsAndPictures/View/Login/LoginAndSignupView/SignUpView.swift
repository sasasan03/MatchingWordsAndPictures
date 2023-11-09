//
//  SignUpView.swift
//  FBSampleApp
//
//  Created by sako0602 on 2023/08/26.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseStorage


struct SignUpView: View {
    
    private func setErrorMessage(_ error: Error?) -> String? {
        guard let error = error as NSError?,
              let authErrorCode = AuthErrorCode.Code(rawValue: error._code) else {
            return "原因不明"
        }
        switch authErrorCode {
        case .networkError:
            return AuthError.networkError.title
            // パスワードが条件より脆弱であることを示します。
        case .weakPassword:
            return AuthError.weakPassword.title
            // ユーザーが間違ったパスワードでログインしようとしたことを示します。
        case .wrongPassword:
            return AuthError.wrongPassword.title
            // ユーザーのアカウントが無効になっていることを示します。
        case .userNotFound:
            return AuthError.userNotFound.title
            // メールアドレスの形式が正しくないことを示します。
        case .invalidEmail:
            return AuthError.invalidEmail.title
            // 既に登録されているメールアドレス
        case .emailAlreadyInUse:
            return AuthError.emailAlreadyInUse.title
            // その他のエラー
        default:
            return AuthError.other.title
        }
    }
    
    @Binding var currentShowingView: AuthState
    @AppStorage("uid") var userID = ""
    @State private var mail = ""
    @State private var password = ""
    @State private var erroMessage = ""
    let auth = Auth.auth()
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    //MARK: - エラー処理で使用
    @State var signInError:AuthError?
    @State var showError = false
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea(.all)
            
            VStack{
                Text("make Account")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    
                Spacer()
                //MARK: - mail
                HStack{
                    Image(systemName: "mail")
                    TextField("mail", text: $mail)
                    
                    Spacer()
                    
                    Image(systemName: mail.isValidEmail() ? "checkmark" : "xmark")
                        .foregroundColor(mail.isValidEmail() ?.green : .red)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                //MARK: - password
                HStack{
                    Image(systemName: "lock")
                    TextField("password", text: $password)
                    
                    Spacer()
                    
                    Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                        .foregroundColor(isValidPassword(password) ?.green : .red)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                
                Spacer()
                
                Text(erroMessage)
                    .foregroundColor(.black)
                Spacer()
                
                //MARK: - 登録ボタン
                Button("登録する"){
                    //TODO: アドレスとパスワードの登録。認証<Void,Error>
                    Task<Void,Error> {
                        do {
                            let authResult = try await auth.createUser(withEmail: mail, password: password)
                            let userID = authResult.user.uid
                            self.userID = userID
                            erroMessage = "登録が完了しました。"
                        } catch let error as NSError {
                            showError = true
                            guard let error = setErrorMessage(error) else {
                                return print("原因不明のエラー")
                            }
                            erroMessage = error
                            print(error)
                        }
                    }
                    
                    //TODO: サクセスビューへの遷移

                }
                .foregroundColor(.white)
                .padding()

            }
            //エラーを表示するアラート
            .alert(isPresented: $showError, error: signInError) {
                Button("承知"){
                    if signInError == nil {
                        withAnimation{
                            currentShowingView = .login
                        }
                    }
                }
            }
            .padding()
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(currentShowingView: .constant(AuthState.signUp))
    }
}
