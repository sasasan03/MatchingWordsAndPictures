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
    
    @State private var userRole = "" //UIDになる
    @State private var image:UIImage? //= UIImage(named: "sakoda")
    @State private var sampleMan:UIImage? = UIImage(named: "sampleMan")
    
    var uid = Auth.auth().currentUser?.uid ?? ""
    
    var body: some View {
        VStack{
            if let image = image {
               Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300,height: 400)
            } else {
                Color.red.frame(width: 300, height: 200)
            }

            Text("UserRole：\(userRole)")
                .padding()
            
//            Button("画像をアップロード"){
//                uplodeImage()
//            }
//            .padding()
            
            if userRole == "" { //🟥Authからadminというuidを取得してこいってことか？
                Button("admin　アップロード"){
                    guard let aaa =  uplodeImage() else { return }
                }
            } else {
                Text("admin がない")
            }
            
            Button("画像をダウンロード"){
                downloadImage()
            }
            .padding()
        }
        .task {
            do {
//                try await fetchUserRole()
            } catch {
                print("on")
            }
            
        }
    }

    //TODO: ここだけなぜFirestoreを参照しているのかがわからない
    func fetchUserRole() async throws {
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("someDirectory/sampleMan.jpg")
        let db = Firestore.firestore().collection("users").document(uid)
        do {
            let document = try await db.getDocument()
            if let data = document.data() {
                self.userRole = data["role"] as? String ?? ""
                }
            }catch {
                print("🍔 fetch error ")
            }
        }
    
    //TODO: 検証する
//    func uplodeImage(){
//        guard let image = sampleMan, let data = image.jpegData(compressionQuality: 0.6) else { return print("🍔 image nil error") }
//        print("🟠")
//        let storageRef = Storage.storage().reference().child("someDirectory/sampleMan.png")
//        print("🔴")
//        storageRef.putData(data, metadata: nil)
//        print("🟡")
//    }
    func uplodeImage() -> StorageUploadTask? {
        guard let imageS = UIImage(named: "sampleMan") else { return nil }
        guard let data = imageS.pngData() else { return nil }
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("sampleMan")
        let uploadTask = imageRef.putData(data) { metadata, error in
            guard let metadata = metadata else {
                return
            }
            //
//            let size = metadata.size
        }
        return uploadTask
    }
    
    
    //🟦検証済み
    func downloadImage(){
        print("🍔uid：",uid)
        let storageRef = Storage.storage().reference().child("someDirectory/sakoda.png")
        let fullpath = storageRef.fullPath
        let name = storageRef.name
        let bucket = storageRef.bucket
        print("🍑",fullpath,"🍑",name,"🍑",bucket)
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
