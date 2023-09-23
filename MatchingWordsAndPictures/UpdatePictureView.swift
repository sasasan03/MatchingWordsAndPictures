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
    
    var body: some View {
        VStack{
            Image("sakoda")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Button("画像をアップロード"){
//                print("🍔")
                uploadImage()
            }
        }
    }
}

func uploadImage22(){
    //ルートフォルダへの参照を取得
    let strage = Storage.storage()
    let reference = strage.reference()
}

func uploadImage(){
    let storageFB = Storage.storage().reference(forURL: "gs://independentactivitysampleapp.appspot.com/")//.child("Item")
    
    let image = UIImage(named: "sakoda.jpg")
    
    let data = image!.jpegData(compressionQuality: 1.0)!
    
    storageFB.putData(data as Data, metadata: nil) { (data, error) in
        if error != nil {
            return
        }
        
    }
}

struct UpdatePictureView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePictureView()
    }
}
