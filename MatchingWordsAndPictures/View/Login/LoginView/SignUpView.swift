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



enum LoginError: LocalizedError {
    case inVaildMail
    case inValidPass
    case unKnown
    
    var errorDescription: String? {
        switch self {
        case .inVaildMail: return "メール間違い"
        case .inValidPass: return "入力したパスワード間違い"
        case .unKnown: return "わかんね"
        }
    }
    
}

struct SignUpView: View {
    
    @Binding var currentShowingView: AuthState
    @AppStorage("uid") var userID = ""
    @State private var mail = ""
    @State private var password = ""
    @State private var loginStatusMessage = ""
    
    //MARK: - エラー処理で使用
    @State var loginError: LoginError? = nil
    @State var showAlert = false
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea(.all)
            
            VStack{
                Text("とうろく")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    
                Spacer()
                //MARK: - mail
                HStack{
                    Image(systemName: "mail")
                    TextField("mail", text: $mail)
                    
                    Spacer()
                    
                    Image(systemName: mail.count != 0 ? "checkmark" : "xmark")
                        .foregroundColor(mail.count != 0 ?.green : .red)
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
                    Image(systemName: "mail")
                    TextField("mail", text: $password)
                    
                    Spacer()
                    
                    Image(systemName: password.count != 0 ? "checkmark" : "xmark")
                        .foregroundColor(password.count != 0 ?.green : .red)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                
                Spacer()
                Text(loginStatusMessage)
                    .foregroundColor(.black)
                Spacer()
                
                //MARK: - 登録ボタン
                Button("登録する"){
                    //TODO: アドレスとパスワードの登録。認証
                    
                    Auth.auth().createUser(withEmail: mail, password: password){ authResult , error in
                        guard mail.count == 0 || password.count == 0 else {
                            return
                        }

                        if let error = error as? LoginError {
                           print("🍔")
                        loginError = error//🟥()をつけると解消。評価の優先順位をつけてくれるのか？
                            showAlert = true
                            return
                        }
                        print("🍟")
                        if let authResult = authResult {
                            userID = authResult.user.uid
                        }
                    }
                    //TODO: サクセスビューへの遷移
                    withAnimation{
                        currentShowingView = .loginComplete
                    }
                }
                .foregroundColor(.white)
                .padding()

            }
            .alert(isPresented: $showAlert, error: loginError, actions: { error in
                
                
            }, message: { error in
                Text(error.errorDescription ?? "unknown")
                Button("承知！！"){
                    showAlert = false
                }
            })
            
            .padding()
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(currentShowingView: .constant(AuthState.signUp))
//            .environmentObject(AuthenticationViewModel())
    }
}
