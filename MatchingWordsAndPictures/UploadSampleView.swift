//
//  StorageAndFirestoreSampleView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/10.
// 🟥Keyとなる画面🟥

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseAuth

struct PersonData: Codable{
    @DocumentID var id: String?
    let name: String
    let imageString: String
}

struct UploadSampleView: View {
    
    let sakoda = PersonData(name: "さこだ　ひろみち", imageString: "sakoda")
    let uid = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Image(sakoda.imageString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                Spacer()
                Text(sakoda.name)
                Spacer()
            }
            Spacer()
            Button(action: {
                Task{
                    do {
                        try await uploadFirebase()
                    } catch {
                        
                    }
                }
            }, label: {
                Text("Up Firebase")
                    .frame(width: 250, height: 100)
            })
            .foregroundColor(.white)
            .background(Color.black)
            Spacer()
        }
    }
    
    func uploadFirebase() async throws {
        let uiImage = UIImage(named: sakoda.imageString)
        
        guard let imageName = uiImage?.jpegData(compressionQuality: 0.8) else {
            print("🐦‍⬛no imageName")
            return
        }
        
        //ストレージのデータベースのリファレンス。uidはそれぞれのユーザーのuidを使って作る
        let storageRef = Storage.storage().reference().child("🟥🟥🟥")
        //ファイヤーストアのデータベースのリファレンスを作る。
        let db = Firestore.firestore().collection("users").document("sampleDocument")
        do {
            //ストレージへデータ型（imageName）になった写真を送信する。URLを取得するため。
            storageRef.putData(imageName)
            //ストレージから画像のURLを取得してくる
            let url = try await storageRef.downloadURL()
            
            //urlをString型にするためにaboluteStringを使用する。
            let urlString = url.absoluteString
            
            let person = PersonData(name: sakoda.name, imageString: urlString)
            try db.setData(from: sakoda)
            print("🟢 Upload successful!")
        } catch {
            print("valid URL")
        }
    }
}

struct UploadSampleView_Previews: PreviewProvider {
    static var previews: some View {
        UploadSampleView()
    }
}
