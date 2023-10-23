//
//  DownloadSmapleView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/20.
//☑️ firestoreから画像をダウンロードしてくる
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseAuth

//struct PersonData: Codable{
//    @DocumentID var id: String?
//    let name: String
//    let imageString: String
//}

struct DownloadSmapleView: View {
    
    let uid = Auth.auth().currentUser?.uid
    
    @State var imageURL: URL?
    @State var fetchData: PersonData
    
    var body: some View {
        VStack{
            HStack{
//                AsyncImage(url:URL(string: fetchData.imageString)) { image in
//                    let _ = print("🟢",image)
//                    image.image?
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 400, height: 300)
//                }
                AsyncImage(url: imageURL) { image in
                    image
                }placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 200 )
                Text(fetchData.name)
            }
        }
        .task {
            do {
                try await fetchData()
            } catch {
                print("🟥：fetch error")
            }
        }
    }
    
    func fetchData() async throws{
        guard let uid = uid else {
            print("🟥：uid is nil")
            return
        }
        
        let db = Firestore.firestore().collection("user").document(uid)
        
        do {
            let documentData =  try await db.getDocument()
//            let documentData = try await db.getDocument(as: PersonData.self)
            print("###1")
            let data = try documentData.data(as: PersonData.self)
//            let imageURL = try await storage.downloadURL()
            print("###2")
            fetchData = data
//            fetchData = documentData
            print("###3")
            imageURL = URL(string: fetchData.imageString)!
            print("🟢 download successful!")
        } catch {
            print("valid URL")
        }
    }
}



struct DownloadSmapleView_Previews: PreviewProvider {
    
    func imageURL() -> URL{
        let url = URL(string: "sasasa")
        guard let url = url else { return URL(string: "")! }
        return url
    }
    
    static var previews: some View {
        DownloadSmapleView(imageURL: URL(string: "uid")!, fetchData: PersonData(name: "データを取得しています", imageString: "suzuki"))
        
    }
}
