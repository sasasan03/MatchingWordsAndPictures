//
//  AVFoundationData.swift
//  ChildToDo
//
//  Created by sako0602 on 2023/06/29.
//

import Foundation
import SwiftUI
import AVFoundation

enum SoundType: String {
    case good
    case bad
    case bibin
    var soundType: String {
        switch self {
        case .good:
            return "correctSound"
        case .bad:
            return "wrongSound"
        case .bibin:
            return "bibinbeanShortVer"
        }
    }
}

class Sound {
    var soundType: SoundType
    init(soundType: SoundType) {
        self.soundType = soundType
    }

    
    func playSound(){
         print(">>>Type", soundType.soundType)
        let sound = try! AVAudioPlayer(data: NSDataAsset(name: soundType.soundType)!.data)
        sound.stop()
        sound.currentTime = 0.0
        sound.play()
    }
}
