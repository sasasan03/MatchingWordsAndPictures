//
//  DownloadSampleView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/10/12.
//

import SwiftUI

struct DownloadSampleView: View {
    
    @State private var imageName = UIImage(named: "サムライ")
    @State private var name = "モモンガ"
    
    var body: some View {
        HStack{
            Spacer()
            if let image = imageName {
                Image(uiImage: image)
            } else {
                Color.red.frame(width: 300, height: 200)
            }
            Spacer()
            Text(name)
            Spacer()
        }
    }
    func imageAndNameDownload(){
        
    }
}

struct DownloadSampleView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadSampleView()
    }
}
