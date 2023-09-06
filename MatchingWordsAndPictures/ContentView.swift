//
//  ContentView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/07/14.
//

import SwiftUI
import AVFoundation



struct ContentView: View {
    
    @State var persons = [
        Person(displayName: "よしい", imageName: "yoshii", isTextChanged: false),
        Person(displayName: "ふくもと", imageName: "hukumoto", isTextChanged: false),
        Person(displayName: "みほこ", imageName: "mihoko", isTextChanged: false),
        Person(displayName: "あつこ", imageName: "atsuko", isTextChanged: false),
        Person(displayName: "さこだ", imageName: "sakoda", isTextChanged: false),
    ]
    @State private var personImage = "atsuko"
    @State private var selectedNum = 0
    @State private var isTextChanged = false
    
    var soundType: SoundType
    let correctData = NSDataAsset(name: "correctSound")!.data
    let incorrectData = NSDataAsset(name: "wrongSound")!.data
    let bibinData = NSDataAsset(name: "bibinbeanShortVer")!.data
    @State var musicPlayer: AVAudioPlayer!
    
    
    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea(.all)
            
            HStack{
            
                Spacer()
                //MARK: - Viewの左の画像
                Image(personImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 300)

                Spacer()
                
                //MARK: - Viewの右の画像
                NameRowView(
                    persons: $persons,
                    personImage: $personImage,
                    isTextChanged: $isTextChanged
                )
                Spacer()
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( soundType: SoundType.bibin)
    }
}
