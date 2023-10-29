//
//  StorageAndFirestoreSampleView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/10.


import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseAuth


struct PersonData: Identifiable,Codable{
    var id = UUID()
    let name: String
    let imageString: String
}

struct UploadSampleView: View {

    let personArraay = [
        PersonData(name: "sakoda", imageString: "sako"),
        PersonData(name: "ランプ", imageString: "lamp"),
        PersonData(name: "標識", imageString: "sky")
    ]
    let uid = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack{
            Spacer()
            //TODO: ID設定の仕方を見直す。
            List(personArraay, id: \.id){ person in
                updateRowView(
                    image: person.imageString,
                    name: person.name
                )
            }
            Spacer()
            Button(action: {
                Task{
                   try await uploadFirebase(datas: personArraay)
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
    
    func uploadFirebase(datas: [PersonData]) async throws {
        
        guard let uid = uid else {
            throw FirebaseError.uidError
        }
        
        for data in datas {
            guard let uiImage = UIImage(named: data.imageString),
                  let imageName = uiImage.jpegData(compressionQuality: 0.8) else {
                throw FirebaseError.getImageError
            }
            //Firebase Storageのリファレンス
            let storageRef = Storage.storage().reference().child("users/\(uid)/\(imageName)")
            do {
                //ストレージへ画像情報をアップロード
                storageRef.putData(imageName)
                //ストレージから画像のURLを取得する
                let url = try await storageRef.downloadURL()
                //urlをString型に変更
                let urlString = url.absoluteString
                //Firebaseに保存する。
                let person = PersonData(name: data.name, imageString: urlString)
                //Firebase
                let db = Firestore.firestore().collection("user").document(uid).collection("persons")
                try db.document("\(person.name)").setData(from: person)
                print("🟢 Upload successful!")
            } catch {
                throw FirebaseError.uploadError
            }
        }
    }
}

//MARK: ListのRowView
struct updateRowView: View {
    let image: String
    let name: String
    var body: some View {
        HStack{
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            Text(name)
        }
    }
}

struct UploadSampleView_Previews: PreviewProvider {
    static var previews: some View {
        UploadSampleView()
    }
}
 
