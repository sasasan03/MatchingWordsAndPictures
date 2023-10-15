//
//  UpdatePictureView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/22.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Person: Codable {
    
    let name: String
    let age: Int
    let favorite: [String]
    let isMarried: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case age
        case favorite
        case isMarried = "Married"
    }
}

struct CloudFireStoreSampleView: View {
    
    @State private var inputText: String = ""
    @State private var saveText: String = ""
    @State var fetchData:Person
    
    let firestore = Firestore.firestore()
    
    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea(.all)
            
            VStack{
                TextField("テキスト", text: $inputText)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                Button("保存"){
                    do {
                         try updataSubcollection()
                    } catch {
                        print("upload Error")
                    }
//                    sampleGetDocumet()
//                    saveTextToFirestore(text: inputText)
//                    uploadSample(str: "ここ",str2: "もも")
                }
                .padding()
                
                Text("保存されたテキスト： \(saveText)")
                    .font(.largeTitle)
                Group{
                    Text(fetchData.name)
                    Text("\(fetchData.age)")
                    Image(systemName: fetchData.isMarried ? "checkmark.seal.fill" : "pencil")
                    List(fetchData.favorite, id: \.self) { data in
                        let _ = print("🍔",data)
                        Text(data)
                    }
                }
            }
        }
        .task {
            do {
                try await fetchSaveTextFromFirestore()
            } catch {
                print("fetch error")
            }
        }
    }
    
    //⭐️フェッチ問題なし。コードは綺麗に書き直す。
    func fetchSaveTextFromFirestore()  async throws {
        let docRef = firestore.collection("cities").document("BJ")
        do {
            let dataLA = try await docRef.getDocument()
            let id = dataLA.documentID
            let data = dataLA.data()
            let name = data?["name"] as? String ?? "名前なし"
            let age = data?["age"] as? Int ?? 0
            let favorite = data?["favorite"] as? [String] ?? ["nil っす"]
            let isMarried = data?["isMarried"] as? Bool ?? false
            fetchData = Person(name: name, age: age, favorite: favorite, isMarried: isMarried)
        } catch {
            print("error:  fetch error")
        }
    }
    
    //⭐️コレクションに保存させる
    func updataSubcollection() throws {
        let docRef = firestore.collection("cities").document("BJ")
        let sako = Person(name: "佐小田", age: 31, favorite: ["もも","レモン","スイカ"], isMarried: false)
        do {
            try docRef.setData(from: sako)
        } catch {
            print("upload miss")
        }
    }
    //⭐️ドキュメントの値を取ってくる
    func sampleGetDocumet(){
        firestore.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func uploadSample(str: String,str2: String){
        var ref: DocumentReference?
        ref = firestore.collection("users").addDocument(data: [
            "first": str,
            "middle": str2,
            "last": "masa",
            "born": 1994,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    
    
}


//func uploadImage(){
//    let storageFB = Storage.storage().reference(forURL: "gs://independentactivitysampleapp.appspot.com/")//.child("Item")
//
//    let image = UIImage(named: "sakoda.jpg")
//
//    let data = image!.jpegData(compressionQuality: 1.0)!
//
//    storageFB.putData(data as Data, metadata: nil) { (data, error) in
//        if error != nil {
//            return
//        }
//
//    }
//}

struct CloudFireStoreSampleView_Previews: PreviewProvider {
    static var previews: some View {
        CloudFireStoreSampleView(fetchData: Person(name: "あ", age: 100, favorite: ["侍"], isMarried: false))
    }
}
