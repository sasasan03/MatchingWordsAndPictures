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
                            
                        }
                        .foregroundColor(.white)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button {
//                                peristImageStorage(uiImage: uiImage)
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
    
}





struct ImageTextRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTextRegisterView()
    }
}
