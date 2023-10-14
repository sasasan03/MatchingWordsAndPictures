//
//  UpdatePictureView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/22.
//

import SwiftUI
import Firebase
import FirebaseStorage


struct CloudFireStoreSampleView: View {
    
    @State private var inputText: String = ""
    @State private var saveText: String = ""
    
    let firestore = Firestore.firestore()
    
    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea(.all)
            
            VStack{
                TextField("テキスト", text: $inputText)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                Button("保存"){
                    updataSubcollection()
//                    sampleGetDocumetn()
//                    saveTextToFirestore(text: inputText)
//                    uploadSample(str: "ここ",str2: "もも")
                }
                .padding()
                
                Text("保存されたテキスト： \(saveText)")
                    .font(.largeTitle)
            }
        }
        .onAppear{
            fetchSaveTextFromFirestore()
        }
    }
    //⭐️コレクションに保存させる
    func updataSubcollection(){
        let docData: [String: Any] = [
            "stringExample": "Hello world!",
            "booleanExample": true,
            "numberExample": 3.14159265,
            "dateExample": Timestamp(date: Date()),
            "arrayExample": [5, true, "hello"],
            "nullExample": NSNull(),
            "objectExample": [
                "a": 5,
                "b": [
                    "nested": "foo"
                ]
            ]
        ]
        firestore.collection("cities").document("LA")
            .setData([
                "from": "石川",
                "favorite": "野球",//🟥変更部分
                
//                "number": 1//🟥削除
                "dislike": "なす"//🟦新規追加
            ],
                     merge: false
            )
//            .setData([
//                "born": "東京",
//                "favorite": "ディズニーランド"
//            ],
//                     merge: false)
    }
    
    

    
    func sampleGetDocumetn(){
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
    
    func saveTextToFirestore(text: String) {
        firestore.collection("userTexts").document("sako").setData(["text":text])
    }
    
    func fetchSaveTextFromFirestore(){
        firestore.collection("userTexts").document("sako").getDocument { document, err in
            if let document = document, document.exists{
                let data = document.data()
                saveText = data?["momo"] as? String ?? "値なし"
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
        CloudFireStoreSampleView()
    }
}
