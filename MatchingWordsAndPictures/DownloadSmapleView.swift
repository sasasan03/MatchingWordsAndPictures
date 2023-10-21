//
//  DownloadSmapleView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/20.
//☑️uidを使ってデータをダウンロードしてくる

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseAuth

struct DownloadSmapleView: View {
    
    let uid = Auth.auth().currentUser?.uid
    
    @State var imageURL: URL
    
    var body: some View {
        VStack{
            HStack{
                AsyncImage(url: imageURL) { image in
                    image.image?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 300)
                }
                Text("Hello, World!後で書き換える")
            }
        }
        .task {
            
        }
    }
    
    func fetchData() async throws{
        guard let uid = uid else {
            print("🟥：uid is nil")
            return
        }
//        let imageRef = storageRef.child(uid)
        
        //ストレージのデータベースのリファレンス。uidはそれぞれのユーザーのuidを使って作る
        let storageRef = Storage.storage().reference().child("\(uid)")
        //ファイヤーストアのデータベースのリファレンスを作る。
        let db = Firestore.firestore().collection("user").document(uid)
        do {
            //ストレージへデータ型（imageName）になった写真を送信する。URLを取得するため。
//            storageRef.putData(imageName)
            //ストレージから画像のURLを取得してくる
            let url = try await storageRef.downloadURL()
            imageURL = url
            //urlをString型にするためにaboluteStringを使用する。
//            let urlString = url.absoluteString
//            let person = PersonData(name: sakoda.name, imageString: urlString)
//            try db.setData(from: person)
            print("🟢 download successful!")
        } catch {
            print("valid URL")
        }
    }
}

struct DownloadSmapleView_Previews: PreviewProvider {
    
    static var previews: some View {
        
            DownloadSmapleView(imageURL: URL(string: "aaa")!)
        
    }
}
