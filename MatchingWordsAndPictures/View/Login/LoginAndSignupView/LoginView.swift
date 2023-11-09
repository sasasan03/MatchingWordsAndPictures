//
//  LoginView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/22.
//

import SwiftUI
import Combine
import FirebaseAnalytics
import FirebaseAuth

struct LoginView: View {
    
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
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    @AppStorage("uid") var userID = ""
    @Binding var currentShowingView: AuthState
    @State var email = ""
    @State var password = ""
    @State var errorMessage:String?
    @State private var showError = false
    @State private var loginError: AuthError?
    
    let auth = Auth.auth()
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.yellow.edgesIgnoringSafeArea(.all)
                VStack{
                    Text("Welcom Back!!")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    HStack{
                        Image(systemName: "mail")
                        TextField("Email", text: $email)
                        
                        Spacer()
                        
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .foregroundColor(email.isValidEmail() ?.green : .red)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                    HStack{
                        Image(systemName: "lock")
                        TextField("password", text:  $password)
                        Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                            .foregroundColor(isValidPassword(password) ? .green : .red)
                       
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                    Button("ログイン"){
                        Task<Void, Error>{
                            do {
                               try await auth.signIn(withEmail: email, password: password)
                                withAnimation{
                                    currentShowingView = .loginComplete
                                }
                            } catch {
                                if let error = error as? AuthErrorCode {
                                    print("##",error)
                                }
                                showError = true
                                //TODO: おそらくサーバー側エラーか、
                                errorMessage = setErrorMessage(error)
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    if let errorMessage {
                        Text(errorMessage)
                    } else {
                        Text("エラーなし")
                    }
                    Spacer()

                    //MARK: - SignViewへの移動処理
                    HStack{
                        Text("まだ登録をしていない人は")
                        Button("こっち"){
                            withAnimation{
                                currentShowingView = .signUp
                            }
                        }
                    }.padding()
                    Spacer()
                }
                .padding()
            }
            .alert(isPresented: $showError, error: loginError) {
                Button("了解"){
                    showError = false
                }
            }
        }
       
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentShowingView: .constant(AuthState.login))
    }
}
