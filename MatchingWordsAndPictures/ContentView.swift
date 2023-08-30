//
//  ContentView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/07/14.
//

import SwiftUI
import AVFoundation

struct Person: Hashable {
    let displayName: String
    let imageName: String
}

struct ContentView: View {
    
    @State var persons = [
        Person(displayName: "よしい", imageName: "yoshii"),
        Person(displayName: "ふくもと", imageName: "hukumoto"),
        Person(displayName: "みほこ", imageName: "mihoko"),
        Person(displayName: "あつこ", imageName: "atsuko"),
        Person(displayName: "さこだ", imageName: "sakoda"),
        Person(displayName: "しらないひと", imageName: "sampleMan")
    ]
    @State private var personImage = "atsuko"
    @State private var selectedNum = 0
    
    var soundType: SoundType
    let correctData = NSDataAsset(name: "correctSound")!.data
    let incorrectData = NSDataAsset(name: "wrongSound")!.data
    let bibinData = NSDataAsset(name: "bibinbeanShortVer")!.data
    @State var musicPlayer: AVAudioPlayer!
    
    
    var body: some View {
        ZStack{
            Color.accentColor.ignoresSafeArea(.all)
            
            HStack{
            
                Spacer()
                //MARK: - 左の画像
                Image(personImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 300)
                    .padding(50)

                Spacer()
                
                //MARK: - 右の画像
                nameRowView(
                    persons: $persons,
                    personImage: $personImage
                )
            }
        }
    }
}

struct nameRowView: View {
    
    @Binding var persons : [Person]
    @Binding var personImage: String
    @State var musicPlayer: AVAudioPlayer!
    @State private var count = 0
    @State private var picture = "atsuko"
    
    let correctData = NSDataAsset(name: "correctSound")!.data
    let incorrectData = NSDataAsset(name: "wrongSound")!.data
    let bibinData = NSDataAsset(name: "bibinbeanShortVer")!.data
    
    //ランダムな画像を返す
    func randomImage(){
        var randomIndex = Int.random(in: 0 ..< persons.count)
            var randomImage = persons[randomIndex].imageName
            
            // 同じ画像が選ばれた場合は、違う画像が選ばれるまでループ
            while randomImage == personImage {
                randomIndex = Int.random(in: 0 ..< persons.count)
                randomImage = persons[randomIndex].imageName
            }
            personImage = randomImage
    }
    
    //ボタンが押された１秒後に画像を更新する
    func changeImage(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            randomImage()
        }
    }
    
    var body: some View{
        HStack {
            
            Spacer()
            
            //MARK: - 右のボタン画面
            VStack{
                ForEach(persons, id: \.self ){ text in
                    Spacer()
                    Text(text.displayName)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                        .onTapGesture(count: 2) {
                            //MARK: 正解したとき
                            if personImage == text.imageName {
                                count += 1
                                if count % 5 == 0 {
                                    do {
                                        musicPlayer = try AVAudioPlayer(data: bibinData)
                                        musicPlayer.play()
                                        changeImage()
                                    } catch {
                                        print("再生ミス")
                                    }
                                } else {
                                    do {
                                        musicPlayer = try AVAudioPlayer(data: correctData)
                                        musicPlayer.play()
                                        changeImage()
                                    } catch {
                                        print("再生ミス")
                                    }
                                }
                                //MARK: 不正解だったとき
                            } else {
                                do {
                                    musicPlayer = try AVAudioPlayer(data: incorrectData)
                                    musicPlayer.play()
                                } catch {
                                    print("再生ミス")
                                }
                            }
                        }
                    //MARK: - 終了
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( soundType: SoundType.bibin)
    }
}
