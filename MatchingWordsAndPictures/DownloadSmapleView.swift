//
//  DownloadSmapleView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/20.
//☑️ firestoreから画像をダウンロードしてくる
//

//struct PersonData: Codable{
//    @DocumentID var id: String?
//    let name: String
//    let imageString: String
//}


import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseAuth

struct DownloadSmapleView: View {
    
    let uid = Auth.auth().currentUser?.uid
    
    @State var imageURL: URL?
    @State var fetchData: PersonData?
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                }placeholder: {
                    ProgressView()
                }
                Spacer()
                if let fetchData = fetchData {
                    Text(fetchData.name)
                } else {
                    Text("downloading name")
                }
                Spacer()
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
            let data = try documentData.data(as: PersonData.self)
            fetchData = data
            guard let fetchData = fetchData else { return print("### personData is nil")}
            imageURL = URL(string: fetchData.imageString)
            guard let imageURL = imageURL else { return print("### invaild imageURL") }
            print("🟢 download successful",imageURL)
        } catch {
            print("???? error")
        }
    }

}


struct DownloadSmapleView_Previews: PreviewProvider {
    
    static var previews: some View {
        DownloadSmapleView()
        
    }
}
