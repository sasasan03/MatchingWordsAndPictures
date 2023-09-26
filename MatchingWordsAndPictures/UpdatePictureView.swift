//
//  UpdatePictureView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/22.
//

import SwiftUI
import Firebase
import FirebaseStorage


struct UpdatePictureView: View {
    
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
                    saveTextToFirestore(text: inputText)
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

struct UpdatePictureView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePictureView()
    }
}
