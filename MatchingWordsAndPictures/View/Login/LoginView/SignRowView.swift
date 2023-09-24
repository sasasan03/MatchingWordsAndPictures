//
//  SignRowView.swift
//  FBSampleApp
//
//  Created by sako0602 on 2023/08/29.
//

import SwiftUI
import FirebaseAuth

struct SignRowView: View {
    
    @Binding var signInError: LoginValidationError
    @Binding var isShowingAlert: Bool
    @State var mail = ""
    @State var password = ""
    
    var body: some View {
        VStack{
            //MARK: - メール記入欄
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
            //MARK: - パスワード記入欄
            HStack{
                Image(systemName: "lock")
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
        }
        
    }
}

struct SignRowView_Previews: PreviewProvider {
    static var previews: some View {
        SignRowView(
            signInError: .constant(LoginValidationError.passwordError),
            isShowingAlert: .constant(false)
        )
    }
}
