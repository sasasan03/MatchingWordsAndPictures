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
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
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
                            } catch let error as NSError {
                                if let errorCode = AuthErrorCode.Code(rawValue: error.code){
                                    showError = true
                                    switch errorCode {
                                    case .invalidEmail:
                                        loginError = LoginValidationError.emailError
                                    case .wrongPassword:
                                        //TODO: パスワードミスをキャッチできない
                                        loginError = LoginValidationError.passwordError
                                    default:
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
