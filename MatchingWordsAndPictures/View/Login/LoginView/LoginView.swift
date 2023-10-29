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
    case textError
    case passwordError
    case unknownError
    
    var errorDescription: String?{
        switch self {
        case .textError: return "テキストエラー"
        case .passwordError: return "パスワードエラー"
        case .unknownError: return "原因不明"
        }
    }
}

private enum FocusableField: Hashable{
    case email
    case password
}


struct LoginView: View {
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    @FocusState private var focus: FocusableField?
    
    @AppStorage("uid") var userID = ""
    
    @Binding var currentShowingView: AuthState
    @State var email = ""
    @State var password = ""
    
    @State var flag = false
    
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
                        Image(systemName: password.count != 0 ? "checkmark" : "xmark")
                            .foregroundColor(password.count != 0 ? .green : .red)
                       
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                    Button("ログイン"){
                        //TODO: 認証する
                        Auth.auth().signIn(withEmail: email, password: password){ authResult, error in
                            if let error = error {
                                print("🍟",error)
                                return
                            }
                            if let authResult = authResult {
                                print("🍔uid：", authResult.user.uid)
                                withAnimation{
                                    userID = authResult.user.uid
                                    currentShowingView = .loginComplete
                                    
                                }
                            }
                        }
                        //TODO: サクセスビューへの遷移
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
        }
       
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentShowingView: .constant(AuthState.login))
    }
}
