//
//  DownloadTextFirebase.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/24.
//

import SwiftUI

struct DownloadTextFirebase: View {
    
    @State private var downloadImage: UIImage?
    
    var body: some View {
        VStack{
            if let image = downloadImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            }
//            Image("sakoda")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300)
            Button("画像をアップロード"){
                update()
            }
            Button("画像をダウンロード"){
                download()
            }
        }
    }
    
    func update(){
        let storageFB = FirebaseManager.shared.storage.reference(forURL: "gs://matchingwordsandpictures.appspot.com/").child("sakodaNoPicture")
        let image = UIImage(named: "sakoda.jpg")
        let data = image!.jpegData(compressionQuality: 1.0)!
        storageFB.putData(data as Data, metadata: nil) { (data, error) in
            if error != nil {
                return
            }
        }
    }
    
    func download(){
        FirebaseManager.shared.fetchpPictureData { uiImage in
            downloadImage = uiImage
        }
    }
    
}

struct DownloadTextFirebase_Previews: PreviewProvider {
    static var previews: some View {
        DownloadTextFirebase()
    }
}
