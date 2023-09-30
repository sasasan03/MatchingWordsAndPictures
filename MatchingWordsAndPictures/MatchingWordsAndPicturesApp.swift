//
//  MatchingWordsAndPicturesApp.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/07/14.
//
import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct MatchingWordsAndPicturesApp: App {

    //TODO: こいつがコメントアウトされていないとクラッシュが起こる
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            AuthView()
//            SignUpView(currentShowingView: .constant(.signUp))
            DownloadTextFirebase()
        }
    }
    
    init(){
        FirebaseApp.configure()
//        let db = Firestore.firestore()
    }
}
