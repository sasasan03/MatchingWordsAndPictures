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

//MARK: 認証画面の管理
enum AuthState {
    case login
    case signUp
    case loginComplete
}

//MARK: - エラー

enum LoginValidationError: LocalizedError {
    case emailError
    case passwordError
    case unknown
    
    var errorDescription: String?{
        switch self {
        case .emailError: return "emailが間違えています"
        case .passwordError: return "パスワードが間違っています"
        case .unknown: return "原因不明"
        }
    }
}

private enum FocusableField: Hashable{
    case email
    case password
}

//MARK: - View

struct LoginView: View {
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    @AppStorage("uid") var userID = ""
    @Binding var currentShowingView: AuthState
    @State var email = ""
    @State var password = ""
    @State var errorMessage = ""
    @State private var showError = false
    @State private var loginError: LoginValidationError?
    
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
                        
                        Image(systemName: email.count != 0 ? "checkmark" : "xmark")
                            .foregroundColor(email.count != 0 ?.green : .red)
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
                        //TODO: Task{}がよくわからん。エラーが🟦しかでない。間違ったemailアドレスでエラーを吐かせたい
                        Task<Void, Error>{
                            do {
                               try await auth.signIn(withEmail: email, password: password)
                            } catch let error as NSError {
                                if let errorCode = AuthErrorCode.Code(rawValue: error.code){
                                    switch errorCode {
                                    case .invalidEmail:
                                        print("🟥")
                                        loginError = LoginValidationError.emailError
                                    case .wrongPassword:
                                        print("🟦")
                                        loginError = LoginValidationError.passwordError
                                    default:
                                        print("🟡")
                                        loginError = LoginValidationError.unknown
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    Spacer()

                    //MARK: - SignViewへの移動処理
                    HStack{
                        Text("まだ登録をしていない人は")
                        Button("こっち"){
                            //TODO: サインアップビューへの遷移
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
