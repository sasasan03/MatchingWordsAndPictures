//
//  SignRowView.swift
//  FBSampleApp
//
//  Created by sako0602 on 2023/08/29.
//

import SwiftUI
import FirebaseAuth

struct SignRowView: View {
    
    @Binding var signInError: AuthError
    @Binding var isShowingAlert: Bool
    @State var mail = ""
    @State var password = ""
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    var body: some View {
        VStack{
            //MARK: - メール記入欄
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
            //MARK: - パスワード記入欄
            HStack{
                Image(systemName: "lock")
                TextField("mail", text: $password)
                
                Spacer()
                
                Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                    .foregroundColor( isValidPassword(password) ?.green : .red)
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
            signInError: .constant(AuthError.other),
            isShowingAlert: .constant(false)
        )
    }
}
