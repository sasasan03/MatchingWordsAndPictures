import UIKit
import Foundation
import SwiftUI
import AVFoundation

let audioPlayer = try AVAudioPlayer(contentsOf: soundType.url, fileTypeHint:nil)
 audioPlayer.prepareToPlay()
 audioPlayers[soundType] = audioPlayer

if (($0?.isPlaying) != nil) {
      $0?.stop()
      $0?.currentTime = 0
  }


let strings = ["apple", "banana", "orange", "grape", "kiwi"]
let randomIndex = Int.random(in: 0..<strings.count)
let randomElement = strings[randomIndex]
print(randomElement)

let array = ["よしい先生","ふくもと先生","みほこ先生","あつこ先生"," さこだ先生"]

func didTapRandomImageButton(){
    guard let randomName = array.randomElement() else { return print("nilっす")}
    print(randomName)
}

didTapRandomImageButton()
