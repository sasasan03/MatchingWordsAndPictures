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
//    var uuid = UUID()//🟥uuidを付与
    @DocumentID var id: String?
    let name: String
    let imageString: String
}

struct UploadSampleView: View {

    let personArraay = [
        PersonData(name: "さこ", imageString: "sako"),
        PersonData(name: "ランプ", imageString: "lamp"),
        PersonData(name: "空", imageString: "sky")
    ]
    let uid = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack{
            Spacer()
            //TODO: ID設定の仕方を見直す。
            List(personArraay, id: \.name){ person in
                updateRowView(
                    image: person.imageString,
                    name: person.name
                )
            }
            Spacer()
            Button(action: {
                Task{
                    do {
                        try await uploadFirebase(datas: personArraay)
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
    
    func uploadFirebase(datas: [PersonData]) async throws {
        
        guard let uid = uid else {
            print("🟥： uid is nil")
            return
        }
        
        for data in datas {
            guard let uiImage = UIImage(named: data.imageString),
                  let imageName = uiImage.jpegData(compressionQuality: 0.8) else {
                print("🟥: no imageName")
                return
            }
            //リファレンス。uidはそれぞれのユーザーのuidを使って作る。
            let storageRef = Storage.storage().reference().child("users/\(uid)/\(imageName)")
            //ファイヤーストアのデータベースのリファレンスを作る。
            do {
                //ストレージへデータ型（imageName）になった写真を送信する。URLを取得するため。
                storageRef.putData(imageName)
                //ストレージから画像のURLを取得してくる
                let url = try await storageRef.downloadURL()
                //urlをString型にするためにaboluteStringを使用する。
                let urlString = url.absoluteString
                
                //Firebaseに保存する
                let person = PersonData(name: data.name, imageString: urlString)
                let db = Firestore.firestore().collection("user").document(uid).collection("persons")
                try db.document("\(person.name)").setData(from: person, merge: true)
                print("🟢：Upload successful!")
            } catch {
                print("🟥：error")
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
