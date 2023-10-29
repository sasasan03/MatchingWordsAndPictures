//
//  DownloadSmapleView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/20.

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
    @State var fetchDatas: [PersonData]?
    @State var testUID: String?
    
    var body: some View {
        List(fetchDatas ?? [PersonData(name: "no name", imageString: "")], id: \.id){ fetchData in
            downloadRowView(fetchData: fetchData)
        }
        .task {
            do {
                try await fetchData()
            } catch {
                print("🟥：fetch error")
            }
        }
    }
    
    //⭐️コレクションのクエリについて調べる
    func fetchData() async throws {
        guard let uid = uid else {
            print("🟥：uid is nil")
            return
        }
        let collectionRef = Firestore.firestore().collection("user").document(uid).collection("persons")
        do {
            let querySnapshot = try await collectionRef.getDocuments()
            let personData = try querySnapshot.documents.map({ document in
                try document.data(as: PersonData.self)
            })
            fetchDatas = personData
            print("🟢 download successful")
        } catch {
            print("???? error")
        }
    }

}

struct downloadRowView: View{
    
    let fetchData: PersonData
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: fetchData.imageString)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            }placeholder: {
                ProgressView()
            }
            .padding()
            Text(fetchData.name)
        }
    }
}

struct DownloadSmapleView_Previews: PreviewProvider {
    
    static var previews: some View {
        DownloadSmapleView()
        
    }
}
