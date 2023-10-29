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
        List(fetchDatas ?? [PersonData(name: "no image", imageString: "noimage")], id: \.name){ fetchData in
            downloadRowView(fetchData: fetchData)
        }
//        VStack{
//            HStack{
//                Spacer()
//                AsyncImage(url: imageURL) { image in
//                    image
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 300)
//                }placeholder: {
//                    ProgressView()
//                }
//                Spacer()
//                if let fetchData = fetchData {
//                    Text(fetchData.name)
//                } else {
//                    Text("downloading name")
//                }
//                Spacer()
//            }
//        }
        .task {
            do {
                try await fetchData()
            } catch {
                print("🟥：fetch error")
            }
        }
    }

    func fetchData() async throws {
        guard let uid = uid else {
            print("🟥：uid is nil")
            return
        }
        
        let db = Firestore.firestore().collection("user").document(uid)
        
        do {
            var documentDatas =  try await db.getDocument()
//            for documentData in documentDatas {
//                print("🍔：",documentData.data())
//                let data = try documentData.data(as: [PersonData].self)
//                fetchDatas?.append(data)
//            }
            
//            guard let fetchDatas = fetchDatas else { return print("#### no data") }
//            for fetchData in fetchDatas {
//                
//            }
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
            Spacer()
            AsyncImage(url: URL(string: fetchData.imageString)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            }placeholder: {
                ProgressView()
            }
            Spacer()
            Text(fetchData.name)
            Spacer()
        }
    }
}

struct DownloadSmapleView_Previews: PreviewProvider {
    
    static var previews: some View {
        DownloadSmapleView()
        
    }
}
