//
//  StorageAndFirestoreSampleView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/10.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct StorageAndFirestoreUploadSampleView: View {
    
    @State var name = "さこだ　ひろみち"
    @State var imageName = UIImage(named: "sakoda")
    
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
                Text(name)
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
        guard let imageName = imageName?.jpegData(compressionQuality: 0.8) else {
            print("🟥no imageName")
            return
        }
        //MARK: コレクションとドキュメントを指定していない
        print("🟧")
        let db = Firestore.firestore().collection("users").document("sampleDocument")
        print("🟨")
        let storageRef = Storage.storage().reference().child("images/uid")
        let url: URL
        print("🐈")
        do {
            print("😃")
           url = try await storageRef.downloadURL()
            print("🔲")
            let nameAndImageURL:[String: Any] = [
                "name": name,
                "imageURL": url.absoluteString
            ]
            print("🔳")
            try await db.setData(nameAndImageURL)
        } catch {
            print("valid URL")
        }
        
        
    }
    
}

struct StorageAndFirestoreUploadSampleView_Previews: PreviewProvider {
    static var previews: some View {
        StorageAndFirestoreUploadSampleView()
    }
}
