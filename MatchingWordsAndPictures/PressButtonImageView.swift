//
//  PressButtonImageView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/06.
//

import SwiftUI

struct PressButtonImageView: View {
    
    @State private var isPressed = false
    @State private var isTextChange = false
    
    var body: some View {
        VStack {
            ZStack{
                Rectangle()
                    .fill(isPressed ? Color.green : Color.blue)
                    .frame(width: 200, height: 200)
                    .cornerRadius(15)
                    .ignoresSafeArea(.all)
                    .onLongPressGesture(minimumDuration: 3, pressing: { pressing in
                        isPressed = pressing
                    }, perform: {
                        isTextChange = true
                    })
                
                Text(isPressed ? "推してる！！" : "おしte")
                    .font(.title)
                
                
            }
            
//            Text("Yheaaaaaaaaaaaa")
            if isTextChange {
                Text("Yheaaaaaaaaaaaa")
            }
        }
    }
}

struct PressButtonImageView_Previews: PreviewProvider {
    static var previews: some View {
        PressButtonImageView()
    }
}
