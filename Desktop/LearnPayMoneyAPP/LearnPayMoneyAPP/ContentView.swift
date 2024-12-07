//
//  ContentView.swift
//  LearnPayMoneyAPP
//
//  Created by sako0602 on 2024/11/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ShopView()
                .tabItem {
                    Text("aaa")
                }
            
        }
        ShopView()
    }
}

#Preview {
    ContentView()
}
