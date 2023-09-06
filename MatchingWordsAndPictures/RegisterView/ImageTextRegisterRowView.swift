//
//  ImageTextRegisterRowView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/06.
//

import SwiftUI

struct ImageTextRegisterRowView: View {
    
    @Binding var text: String
    @Binding var uiImage: UIImage?
    @State var showingPicker = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Spacer()
                VStack{
                    if let image = uiImage {
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
                
                TextField("名前入力", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: geometry.size.width * 0.5)
                
                Spacer()
            }
            .sheet(isPresented: $showingPicker) {
                ImagePickerView(image: $uiImage, sourceType: .library)
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
