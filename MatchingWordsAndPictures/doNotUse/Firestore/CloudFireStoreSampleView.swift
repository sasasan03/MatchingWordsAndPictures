//
//  UpdatePictureView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/22.
//
//✅ドキュメント名をuidにする（クリア）

//🟦.setData()データを上げる。コレクションやドキュメントのな名前を指定することが可能。
//🟦.getDocument()ドキュメントの情報を引っ張ってくる。
//🟦.addDocument()一意のドキュメントを作成


import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
//import SDWebImageSwiftUI

struct CloudFireStoreSampleView: View {
    
    @State private var inputText: String = ""
    @State private var saveText: String = ""
    @State var fetchData:Person
    let uid = Auth.auth().currentUser?.uid
    
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
                    makeDocumet()
//                    addNewCityDoc(city: horyu)//⭐️つこてる
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
//        .task {
//            do {
//                try await fetchSaveTextFromFirestore()
//            } catch {
//                print("fetch error")
//            }
//        }
    }
    
    //コレクションの中にドキュメントを作成し、その中へストレージの画像URLを保存させたい
    func makeDocumet(){
        guard let uid = uid else {
            print("🟥: uid is nil")
            return
        }
        //🟦 uid：q5KjudFHLUeNsraQ7wnYjQADEGI2
        firestore.collection("user").document(uid).setData(["花":"紫陽花"])
        
    }
    
    //⭐️データをフェッチしてくる
    func fetchSaveTextFromFirestore()  async throws {
        let docRef = firestore.collection("cities").document("BJ")
        do {
            let documentData = try await docRef.getDocument(as: Person.self)
            fetchData = documentData
        } catch {
            print("error:  fetch error")
        }
    }
    
    
    //⭐️コレクションに保存させる
    func updataSubcollection()  {
        let docRef = firestore.collection("cities").document("BJ")
        let sako = Person(name: "佐小田", age: 31, favorite: ["もも","りんご"], isMarried: false)
        do {
            try docRef.setData(from: sako, merge: true)
            
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


struct CloudFireStoreSampleView_Previews: PreviewProvider {
    static var previews: some View {
        CloudFireStoreSampleView(fetchData: Person(name: "すずき", age: 100, favorite: ["りんご","もも","オレンジ"], isMarried: false))
    }
}
