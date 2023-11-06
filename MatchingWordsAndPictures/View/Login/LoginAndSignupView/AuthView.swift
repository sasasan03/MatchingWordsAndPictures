//
//  AuthView.swift
//  FBSampleApp
//
//  Created by sako0602 on 2023/08/27.
//

import SwiftUI

struct AuthView: View {
    
    @State var currentShowingView: AuthState = .login
    
    var body: some View {
        VStack{
            if currentShowingView == .login {
                LoginView(currentShowingView: $currentShowingView)
                
            } else if currentShowingView == .signUp {
                SignUpView(currentShowingView: $currentShowingView)
                    .transition(.move(edge: .bottom))
            } else {
                UploadSampleView()
                    .transition(.move(edge: .trailing))
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AuthenticationViewModel())
    }
}
