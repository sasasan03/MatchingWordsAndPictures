//
//  AuthenticationState.swift
//  FBSampleApp
//
//  Created by sako0602 on 2023/08/23.
//

import Foundation
import FirebaseAuth

enum AuthenticationState {
    case unauthenticated//MARK: アカウント作成画面
    case authenticating//MARK: ログイン画面
    case authenticated//MARK: ログイン先のLoginSuccessViewにいる
}

enum AuthenticationFlow {
    case login //MARK: ログイン
    case signUp //MARK: 新規登録
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var flow: AuthenticationFlow = .login  //⭐️MARK: ログイン
    
    @Published var isValid: Bool = false
    @Published var authenticationState: AuthenticationState = .unauthenticated  //⭐️MARK: アカウント作成画面
    @Published var user: User? //⭐️取得してきたユーザー
    @Published var errorMessage: String = ""
    @Published var displayName: String = ""
    
    init(){
        //MARK: 初期の立ち上がりでは、(authStateHandler)はnil
        //🤔🤔🤔🤔Viewの描画処理が走ったら、このinitの処理も走るはず。⇦ ❌
        registerAuthStateHandler()
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map{ flow, email, password, confirmPassword in
                flow == .login//🤔🤔この処理が走る = ボタンが押されて、値に変化があった。
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)//⭐️Combineのメソッド
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    //MARK:
    func registerAuthStateHandler(){
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener({ auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
            })
        }
    }
    
    //MARK: ログイン画面の新規登録（signUp）ボタンを押すと処理が走る。押される前は.Login。押された後は.signUp
    func switchFlow(){
        //MARK: flowの状態がログインであれば、サインアップに変更し、ログインでなければログインにする。
        flow = flow == .login ? .signUp : .login
        errorMessage = "エラーだよーん"
    }
    
    private func wait() async {
        do {
            print("wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Done")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func reset(){
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
    
    func call(name: String, _: (Result<Int, Never>) -> Void) async {
        
    }
    
}

//MARK: - Sign in with Email and Password

extension AuthenticationViewModel {
    
    //⭐️MARK: サインインで使用
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            user = authResult.user
            print("🍔User: \(authResult.user.uid) signed in")
            authenticationState = .authenticated
            displayName = user?.email ?? "(unknown)"
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    //⭐️MARK: 新しいアカウント作成で使用
    func signUpWithEmailpassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            user = authResult.user

            authenticationState = .authenticated
            displayName = user?.email ?? "(unknown)"
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    //⭐️MARK: サインアウト時に使用
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    //⭐️MARK: アカウント削除時に使用
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
