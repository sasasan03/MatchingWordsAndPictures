//
//  ImageTextRegisterView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/06.
//

import SwiftUI

struct ImageTextRegisterView: View {
    
    @State private var rows: [ImageText] = Array(repeating: ImageText(), count: 4)
    
    @State var showingPicker = false
    @State var uiImage: UIImage?
    @State var text = ""
    @State var isPresented = false
    @State var loginStateMessage = ""
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                ZStack{
                    Color.cyan.ignoresSafeArea(.all)
                    VStack{
                        VStack{
                            Spacer()
                            ForEach(0..<rows.count, id: \.self){ index in
                                ImageTextRegisterRowView(text: $rows[index].text, uiImage: $rows[index].image)
                            }
                            Spacer()
                        }
                        
                        NavigationLink("問題に挑戦する") {
                            MatingView()
                        }
                        .foregroundColor(.white)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button {
                                peristImageStorage(uiImage: uiImage)
                            } label: {
                                Text("保存")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func peristImageStorage(uiImage: UIImage?){
        print("🍊",uiImage ?? "uiImageは空だよ")
        guard let uiImage = uiImage else { return }
        print("🟥", FirebaseManager.shared.auth.currentUser?.uid ?? "uidないよ〜〜")
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        print("🟦")
        guard let imageData = self.uiImage?.jpegData(compressionQuality: 0.5) else { return }
        print("🟢")
        ref.putData(imageData, metadata: nil) { metaData, err in
            print("🟨")
            if let err = err {
                loginStateMessage = "Failed to push image to Storage: \(err)"
                return
            }
            print("🟣")
            ref.downloadURL { url, err in
                if let err {
                    loginStateMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                loginStateMessage = "Successfully stored image with url: \(url?.absoluteString ?? "もものすけ")"
            }
        }
    }
    
}





struct ImageTextRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTextRegisterView()
    }
}
