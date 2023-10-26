//
//  StorageAndFirestoreSampleView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/10.
// 🟥Keyとなる画面🟥
//☑️ Firestoreのuidドキュメントへ画像のURLを保存する
//☑️ Storageリファレンスの一つ下位のuidディレクトリ（フォルダ）に画像を保存する

//uidフォルダを作成し、画像のデータをアップロードする
//

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
    
    let sako = PersonData(name: "さこ みち", imageString: "sako")
    let uid = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Image(sako.imageString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                Spacer()
                Text(sako.name)
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
        let uiImage = UIImage(named: sako.imageString)
        
        guard let imageName = uiImage?.jpegData(compressionQuality: 0.8) else {
            print("🐦‍⬛no imageName")
            return
        }
        guard let uid = uid else {
            print("🟥： uid is nil")
            return
        }
        
        //ストレージのデータベースのリファレンス。uidはそれぞれのユーザーのuidを使って作る
        let storageRef = Storage.storage().reference().child("\(uid)/\(imageName)")
        //ファイヤーストアのデータベースのリファレンスを作る。
        let db = Firestore.firestore().collection("user").document(uid)
        do {
            //ストレージへデータ型（imageName）になった写真を送信する。URLを取得するため。
            storageRef.putData(imageName)
            //ストレージから画像のURLを取得してくる
            let url = try await storageRef.downloadURL()

            //urlをString型にするためにaboluteStringを使用する。
            let urlString = url.absoluteString

            let person = PersonData(name: sako.name, imageString: urlString)
            try db.setData(from: person)
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
