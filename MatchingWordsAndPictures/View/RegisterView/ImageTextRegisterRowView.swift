//
//  ImageTextRegisterRowView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/06.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

//TODO: rowでの保存ができるが、全体からの保存がまだうまくできていない。

struct ImageTextRegisterRowView: View {
    
    @Binding var text: String
    @Binding var uiImage: UIImage?
    @State var showingPicker = false
    @State var loginStateMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Spacer()
                VStack{
                    if let image = uiImage {
                        let _ = print("🧡", image)
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:  geometry.size.width * 0.3, height: geometry.size.height)
                    } else {
                        Rectangle()
                            .frame(width:  geometry.size.width * 0.3, height: geometry.size.height)
                            .onTapGesture(count: 1){
                                showingPicker = true
                            }
                    }
                }
                
                Spacer()
                VStack{
                    TextField("名前入力", text: $text)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: geometry.size.width * 0.5)
                    Button("保存"){
                        peristImageStorage(uiImage: uiImage)
                    }
                    Text(loginStateMessage)
                }
                
                Spacer()
            }
            .sheet(isPresented: $showingPicker) {
                ImagePicker(image: $uiImage, sourceType: .library)
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
                print("🟤")
                loginStateMessage = "Successfully stored image with url: \(url?.absoluteString ?? "もものすけ")"
            }
        }
    }
    
}

struct ImageTextRegisterRowView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTextRegisterRowView(
            text: .constant("りんご"),
            uiImage: .constant(UIImage(named: "sakoda"))
        )
    }
}
