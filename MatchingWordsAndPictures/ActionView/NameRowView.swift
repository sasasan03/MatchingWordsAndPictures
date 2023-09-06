//
//  NameRowView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/06.
//

import SwiftUI
import AVFoundation

struct NameRowView: View {
        
        @Binding var persons : [Person]
        @Binding var personImage: String
        @Binding var isTextChanged: Bool
        
        @State var musicPlayer: AVAudioPlayer!
        @State private var count = 0
        @State private var picture = "atsuko"
    //    @State private var isPressed = false
        
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1  ) {
                randomImage()
            }
        }
        
        var body: some View{
            HStack {
                
                //MARK: - 右のボタン画面（　ForEachから）
                VStack{
                    ForEach(persons.indices, id: \.self ){ index in
                        Spacer()
                        ZStack {
                            Color(persons[index].isTextChanged ? .gray : .white)
    //                        Color(isTextChanged ? .gray : .white)
                                .frame(width: 300, height: 100)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.black, lineWidth: 5)
                                )
                            
                        Text(persons[index].displayName)
                                .foregroundColor(.black)
                                .font(.system(size: 50))
                                .bold()
                                .onLongPressGesture(minimumDuration: 3, pressing: { pressing in
                                    persons[index].isTextChanged = pressing
                                }, perform: {
                                    //MARK: 正解したとき
                                    if personImage == persons[index].imageName {
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
                                )
                            //MARK: - 終了
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
}

struct NameRowView_Previews: PreviewProvider {
    static var previews: some View {
        NameRowView(
            persons: .constant(
                [
                    Person(
                        displayName: "さこ",
                        imageName: "sakoda",
                        isTextChanged: false)
                ]
            ),
            personImage: .constant("sako"),
            isTextChanged: .constant(false))
    }
}
