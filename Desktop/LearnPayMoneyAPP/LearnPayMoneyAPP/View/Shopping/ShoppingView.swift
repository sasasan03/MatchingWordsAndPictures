//
//  ShopView.swift
//  LearnPayMoneyAPP
//
//  Created by sako0602 on 2024/11/15.
//

import SwiftUI

struct ShoppingView: View {
    @State var gohyakuYen: [CashItem] = []
    @State var hyakuYen: [CashItem] = []
    @State var juYen: [CashItem] = []
    @State var isNotButtonEnabled = false
    @State var totalPay = 0
    let totalAmount = 610
    @State var isCorrect = false
    @State var text = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack{
                    Image("shop")
                        .resizable()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    VStack{
                        Image("tray")
                            .resizable()
                            .frame(width: geometry.size.width * 0.7,
                                   height: geometry.size.height * 0.2
                            )
                            .offset(y: 50)
                        Spacer()
                    }
                }
                ZStack {
                    ForEach($gohyakuYen){ $cash in
                        Image(cash.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .opacity(cash.isInTray ? 0.3 : 1)
                            .position(x: cash.location == .zero
                                      ? geometry.size.width * cash.startPositionWidth
                                      : cash.location.x,
                                      y: cash.location == .zero
                                      ? geometry.size.height * cash.startPositionHeight
                                      : cash.location.y)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        cash.location = value.location
                                    }
                                    .onEnded { value in
                                        if value.location.y < 200 {
                                            cash.isInTray = true
                                        } else {
                                            cash.isInTray = false
                                        }
                                    }
                            )
                    }
                    ForEach($hyakuYen) { $cash in
                        Image(cash.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .opacity(cash.isInTray ? 0.3 : 1)
                            .position(x: cash.location == .zero
                                      ? geometry.size.width * cash.startPositionWidth
                                      : cash.location.x,
                                      y: cash.location == .zero
                                      ? geometry.size.height * cash.startPositionHeight
                                      : cash.location.y)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        cash.location = value.location
                                    }
                                    .onEnded { value in
                                        if value.location.y < 200 {
                                            cash.isInTray = true
                                            
                                        } else {
                                            cash.isInTray = false
                                        }
                                    }
                            )
                    }
                    ForEach($juYen) { $cash in
                        Image(cash.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .opacity(cash.isInTray ? 0.3 : 1)
                            .position(x: cash.location == .zero
                                      ? geometry.size.width * cash.startPositionWidth
                                      : cash.location.x,
                                      y: cash.location == .zero
                                      ? geometry.size.height * cash.startPositionHeight
                                      : cash.location.y)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        cash.location = value.location
                                    }
                                    .onEnded { value in
                                        //TODO: 横幅の制限もつける
                                        if value.location.y < 200 {
                                            cash.isInTray = true
                                        } else {
                                            cash.isInTray = false
                                        }
                                    }
                            )
                    }
                }
                //MARK: 支払い金額
                VStack {
                    Spacer()
                    Text("610円支払ってください")
                        .font(.system(size: 30))
                    Text(text)
                        .font(.system(size: 25))
                        .foregroundStyle(isCorrect ? .blue : .red )
                    Spacer()
                }
                VStack{
                    Spacer()
                    Button {
                        isCorrect = isPaymentCorrect(totalAmount: totalAmount)
                        text = isCorrect ? "金額と同じです" : "金額と一致しません"
                    } label: {
                        ZStack{
                            Rectangle()
                                .fill(Color.white)
                                .frame(height: geometry.size.height * 0.1)
                            Text("支払う")
                                .font(.system(size: 30))
                        }
                    }
                    .disabled(isNotButtonEnabled)//trueでタップ不可
                }
            }
        }
        .ignoresSafeArea(edges: .all)
        .onAppear{
            gohyakuYen = CashItem(imageName: "gohyaku",
                                  startPositionWidth: 0.6,
                                  startPositionHeight: 0.83,
                                  cashValue: 500).makeBackGroundItem()
            hyakuYen = CashItem(imageName: "hyaku",
                                startPositionWidth: 0.25,
                                startPositionHeight: 0.7,
                                cashValue: 100).makeBackGroundItem()
            juYen = CashItem(imageName: "ju",
                             startPositionWidth: 0.75,
                             startPositionHeight: 0.7,
                             cashValue: 10).makeBackGroundItem()
        }
    }
    
    private func isPaymentCorrect(totalAmount: Int) -> Bool {
        var payMoney = 0
        let trueGohyakueYen = gohyakuYen.filter{ $0.isInTray == true }
        let trueHyakuYen = hyakuYen.filter{ $0.isInTray == true }
        let trueJuYen = juYen.filter{ $0.isInTray == true }
        trueGohyakueYen.forEach{ payMoney += $0.cashValue }
        trueHyakuYen.forEach{ payMoney += $0.cashValue }
        trueJuYen.forEach{ payMoney += $0.cashValue }
        return if totalAmount == payMoney { true } else { false }
    }
    
}

#Preview {
    ShoppingView()
}
