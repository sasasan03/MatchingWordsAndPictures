//
//  StorageAndFirestoreSampleView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/10.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct UploadSampleView: View {
    
    @State var name = "さこだ　ひろみち"
    @State var imageName = UIImage(named: "atsuko")
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                if let imageName = imageName {
                    Image(uiImage: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350)
                }
                Spacer()
//                TextField("入力してください", text: $name)
//                    .textFieldStyle(.roundedBorder)
                Text(name)
                Spacer()
            }
            Spacer()
            Button(action: {
                print("jjj")
                Task{
                    do {
                         try await uploadFirebase()
                    } catch {
                        
                    }
                }
                print("kkk")
            }, label: {
                Text("Up Firebase")
                    .frame(width: 250, height: 100)
            })
            .foregroundColor(.white)
            .background(Color.black)
            Spacer()
        }
    }
    //TODO: かなり無駄が多いように思えるので、後ほど改善
    func uploadFirebase() async throws {
        //MARK: Dataへ変換する
        guard let imageName = imageName?.jpegData(compressionQuality: 0.8) else {
            print("🟥no imageName")
            return
        }
        //MARK: リファレンスを作成
        let db = Firestore.firestore().collection("users").document("sampleDocument")
        let storageRef = Storage.storage().reference().child("images/uid")
        do {
            //MARK: データを指定したポイントへアップロード
            let _ = try await storageRef.putData(imageName)
            //MARK: StorageのURLをダウンロード
            let url = try await storageRef.downloadURL()
            //MARK: ダウンロードしてきたURLへ保存するために辞書型にする。
            let nameAndImageURL:[String: Any] = [
                "name": name,
                "imageURL": url.absoluteString
            ]
            //MARK: 
            try await db.setData(nameAndImageURL)
            print("🟢 Upload successful!")
        } catch {
            print("🟥valid URL")
        }
    }
}

struct UploadSampleView_Previews: PreviewProvider {
    static var previews: some View {
        UploadSampleView()
    }
}
