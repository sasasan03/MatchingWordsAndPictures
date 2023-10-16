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

//struct Person: Codable {
//
//    let name: String
//    let age: Int
//    let favorite: [String]
//    let isMarried: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case age
//        case favorite
//        case isMarried = "Married"
//    }
//}

struct Person: Codable {
    @DocumentID var id: String?
    let name: String
    let age: Int
    let favorite: [String]
    let isMarried: Bool
}

struct City: Codable{
    @DocumentID var id: String?
    var name: String
    var population: Int
    var specialProduct:[String]
}


struct CloudFireStoreSampleView: View {
    
    @State private var inputText: String = ""
    @State private var saveText: String = ""
    @State var fetchData:Person
    
    let firestore = Firestore.firestore()
    let makoto = Person(name: "まこと", age: 32, favorite: ["酒","服"], isMarried: true)
    let horyu = City(name: "宝立", population: 10000, specialProduct: ["お酒","魚"])
    
    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea(.all)
            
            VStack{
                TextField("テキスト", text: $inputText)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                Button("保存"){
                    addNewCityDoc(city: horyu)
//                    addNewPersonDoc(person: makoto)
//                    updataSubcollection()
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
//    func fetchSaveTextFromFirestore()  async throws {
//        let docRef = firestore.collection("cities").document("BJ")
//        do {
//            let dataLA = try await docRef.getDocument()
////            let id = dataLA.documentID
//            let data = dataLA.data()
//            let name = data?["name"] as? String ?? "名前なし"
//            let age = data?["age"] as? Int ?? 0
//            let favorite = data?["favorite"] as? [String] ?? ["nil っす"]
//            let isMarried = data?["isMarried"] as? Bool ?? false
//            fetchData = Person(name: name, age: age, favorite: favorite, isMarried: isMarried)
//        } catch {
//            print("error:  fetch error")
//        }
//    }
    func fetchSaveTextFromFirestore()  async throws {
        let docRef = firestore.collection("cities").document("BJ")
        do {
            let documentData = try await docRef.getDocument(as: Person.self)
            print("🟥",documentData.id)
            fetchData = documentData
//
//            fetchData = try document.data(as: Person.self)
        } catch {
            print("error:  fetch error")
        }
    }
    
    
    //⭐️コレクションに保存させるj
    func updataSubcollection()  {
        let docRef = firestore.collection("cities").document("BJ")
        let sako = Person(name: "佐小田", age: 31, favorite: ["もも","レモン"], isMarried: false)
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
    //⭐️コレクションを指定。新しく一意のドキュメントを作成。（addNewCityDocも一緒）
    func addNewPersonDoc(person: Person){
        let correctionRef = firestore.collection("cities")
        do {
            try correctionRef.addDocument(from: person)
        } catch {
            print("error: addNewPersonDoc")
        }
    }
    func addNewCityDoc(city: City){
        let correctionRef = firestore.collection("cities")
        do {
//           try correctionRef.getDocument(as:City.self)
        } catch {
            print("error: addNewCityDoc")
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
