//
//  DownloadTextFirebase.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Firebase

struct userInfo: Identifiable, Codable{
    var id = UUID().uuidString
    let role: String
}


struct DownloadTextFirebase: View {
    
    @State private var userRole = ""
    @State private var image:UIImage? = UIImage(named: "sakoda")
    
    var uid = Auth.auth().currentUser?.uid ?? ""
    
    var body: some View {
        VStack{
            if let image = image {
               Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300,height: 400)
            }

            Text("UserRole：\(userRole)")
            
            Button("画像をアップロード"){
                uplodeImage()
            }
            
            if userRole == "admin" {
                Button("画像をアップロード"){
                    uplodeImage()
                }
            }
            
            Button("画像をダウンロード"){
                downloadImage()
            }
        }
        .task {
            do {
//                try await fetchUserRole(storageRef: )
            } catch {
                print("on")
            }
            
        }
    }
    //TODO: クラッシュの内容の原因
    func fetchUserRole(storageRef: StorageReference) async throws {
        do {
//             let downloadURL = storageRef.downloadURL()
            
        } catch {
            print("エラー")
        }
        
    }
    func fetchUserRole() async throws {
        let db = Storage.storage()
//        let db = Firestore.firestore()

//            .collection("users").document(uid)
        do {
            let document = try await docRef.getDocument()
            if let data = document.data() {
                self.userRole = data["role"] as? String ?? ""
                }
            }catch {
                print("🍔フェッチエラー")
            }
        }
    
    func uplodeImage(){
        guard let image = image, let data = image.jpegData(compressionQuality: 0.6) else { return }
        print("🟠")
        let storageRef = Storage.storage().reference().child("someDirectory/sakoda.png")
        print("🔴")
        storageRef.putData(data, metadata: nil)
        print("🟡")
    }
    
//    func uplodeImage(){
//
//        let storageRef = Storage.storage().reference().child("someDirectory/sakoda.png")
//
//        guard let image = image, let data = image.jpegData(compressionQuality: 0.6) else { return }
//
//        do {
//            print("🟠")
//            try storageRef.putData(data, metadata: nil)
//        } catch {
//            print("🔴")
//
//        }
//        print("🟡")
//    }
    
    func downloadImage(){
        print("🍔uid：",uid)
        let storageRef = Storage.storage().reference().child("someDirectory/sakoda.png")
        print("🍔storageRf：",storageRef)
        storageRef.getData(maxSize: Int64(10 * 1024 * 1024)) { data, error in
            if let imageData = data {
                self.image = UIImage(data: imageData)
            } else if let error = error {
                print("🍔Error fetching data: \(error.localizedDescription)")
            }
        }
    }
    
}

struct DownloadTextFirebase_Previews: PreviewProvider {
    static var previews: some View {
        DownloadTextFirebase()
    }
}
