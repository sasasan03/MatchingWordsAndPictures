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

struct FirebaseImageView: View  {
    @State private var image: UIImage?
    let imageUrl: URL
    var body: some View {
        Image(uiImage: image ?? UIImage())
            .resizable()
            .onAppear(perform: loadImage)
    }
    
    func loadImage(){
        URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}

struct DownloadTextFirebase: View {
    
    @State private var userRole = "" //UIDになる
    @State private var image:UIImage? //= UIImage(named: "sakoda")
    @State private var sampleMan:UIImage? = UIImage(named: "sampleMan")
    @State private var imageURLs:[URL] = []
    
    var uid = Auth.auth().currentUser?.uid ?? ""
    
    func loadImage(){
        let storage = Storage.storage().reference().child("images/uid")//🟥最後に/をつけて試してみる
        storage.listAll { result, error in
            guard let result = result else { return }
            if let error = error {
                print("###", error)
            }
            for item in result.items {
                item.downloadURL { url, error in
                    if let url = url {
//                        DispatchQueue.main.async {
                            imageURLs.append(url)
//                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        HStack{
            
            //MARK: -
            List(imageURLs, id: \.self){ url in
                FirebaseImageView(imageUrl: url)
            }
            .onAppear(perform: loadImage)
            
            //MARK: -
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
                
                if userRole == "" { //🟥Authからadminというuidを取得してこいってことか？
                    Button("admin　アップロード"){
                        uplodeImage()
                    }
                } else {
                    Text("admin がない")
                }
                
                Button("画像をダウンロード"){
                    downloadImage()
                    //                getMetadata()
                }
                .padding()
                
                //            Button("画像を削除"){
                //                detaDelete()
                //            }
                Button("画像のリストを表示"){
                    //                fetchImage(at: "someDirectory")
                    //                fetchImage(at: "images/")
                    listSample()
                }
            }
        }
        .task {
            do {
//                try await images = fetchImage(at: "someDirectory/uid")
            } catch {
                print("on")
            }
            
        }
    }

    //MARK: - ここだけなぜFirestoreを参照しているのかがわからない
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
    //MARK: -
    func listSample(pageToken: String? = nil){
        let storageRef = Storage.storage().reference()
        let childRef = storageRef.child("images")
        let pageHandler: (StorageListResult?, Error?) -> Void = { result, error in
            if let error = error {
                print("###", error)
            }
            guard let result = result else { return print("result empty")}
//            let prifixes = result.prefixes
//            let items = result.items
            if let token = result.pageToken {
                self.listSample(pageToken: token)
            }
        }
        if let pageToken = pageToken {
            childRef.list(maxResults: 1, pageToken: pageToken, completion: pageHandler)
        } else {
            childRef.list(maxResults: 1, completion: pageHandler)
        }
    }
    //MARK: -
    func fetchImage(at path: String) {
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child(path)
        imageRef.listAll { result, error in
            if let error = error {
                print("###", error)
            }
            guard let resutlt = result else { return }
            //サブディレクトリ（prefixes）の表示
            for prefix in resutlt.prefixes {
                print("$$$Dictionaly：", prefix)
            }
            for item in resutlt.items {
                print("&&&file：", item)
            }
            
        }
        storageRef.listAll { result, err in
            guard let reult = result else { return }
            if let err = err {
                print(err)
            }
//            print("0000",reult.items)
//            print("1111",reult.prefixes)
        }
    }
    //MARK: -
//    func detaDelete(){
//        print(#function)
//        let storageRef = Storage.storage().reference()
//        let sample = storageRef.child("Sample/sampleMan")
//
//        sample.delete { err in
//            if let err = err {
//                print("###",err)
//            } else {
//                print("$$$ delte successfully")
//            }
//        }
//    }
    
    //MARK: -
//   //🟥メタデータ
//    func getMetadata(){
//        print(#function)
//        let storageRef = Storage.storage().reference()
//        let sakodaRef = storageRef.child("someDirectory/sakoda.png")
//
//        sakodaRef.getMetadata { metadata, err in
//            if let err = err {
//                print("###",err)
//            } else {
//                print(metadata?.description)
//            }
//        }
//    }
    //MARK: -
    //TODO: 検証する,nilで返すの微妙
    func uplodeImage() -> StorageUploadTask? {
        guard let imageS = UIImage(named: "sampleMan") else { return nil }
        guard let data = imageS.pngData() else { return nil }
        let storageRef = Storage.storage().reference()
        //どこへ保存したいの？保存場所を作成し、その中へ画像を放り込む
        let imageRef = storageRef.child("Sample/sampleMan")
        let uploadTask = imageRef.putData(data) { metadata, error in
            guard let metadata = metadata else {
                return
            }
            //サイズの指定も可能
//            let size = metadata.size
        }
        return uploadTask
    }
    
    //MARK: -
    //🟦検証済み
    func downloadImage(){
        let storageRef = Storage.storage().reference().child("someDirectory")
//        let fullpath = storageRef.fullPath
//        let name = storageRef.name
//        let bucket = storageRef.bucket
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
