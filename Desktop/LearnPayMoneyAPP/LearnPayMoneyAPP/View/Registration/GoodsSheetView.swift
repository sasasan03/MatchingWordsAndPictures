//
//  GoodsSheetView.swift
//  LearnPayMoneyAPP
//
//  Created by sako0602 on 2024/12/07.
//

import SwiftUI

// グッズの修正か追加を行うためのシート
struct GoodsSheetView: View {
    
    // タプル型に３つはわかりにくため、構造体へ
    struct SaveGood {
        var name: String
        var price: Int
        var uiImage: UIImage
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var goodsName = ""
    @State private var goodsPrice = ""
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    @State private var isError = false
    @State private var errorText = ""
    let imageFileManager = ImageFileManager()
    let shop: Shop
    let goods: Goods?
    let saveGoods: (SaveGood) -> Void
    
    init(shop: Shop ,goods: Goods?, saveGood:  @escaping (SaveGood) -> Void){
        // 遷移時にGoodsを持ってた場合、渡されてきたGoodsをリストへ反映させる
        if let goods {
            goodsName = goods.name
            goodsPrice = String(goods.price)
            selectedImage = imageFileManager.loadGoodsImage(shopName: shop.name, goodsName: goods.name)
        }
        self.shop = shop
        self.goods = goods
        self.saveGoods = saveGood
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let goods { //グッズ編集画面(すでに画像、名前、金額を持っている)
                    if let selectedImage {
                        Image(uiImage:  selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                            .frame(width: 200, height: 200)
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    }
                    HStack {
                        Text("グッズ名")
                            .font(.headline)
                            .frame(width: 80)
                        TextField(goods.name, text: $goodsName)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                        Text("")
                            .frame(width: 30)
                    }
                    HStack {
                        Text("金額")
                            .font(.headline)
                            .frame(width: 80)
                        TextField(String(goods.price), text: $goodsPrice)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("円")
                            .font(.subheadline)
                            .frame(width: 30, alignment: .leading)
                    }
                    
                } else { //グッズ追加画面
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                            .frame(width: 250, height: 250)
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                            .frame(width: 250, height: 250)
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    }
                    
                    HStack {
                        Text("グッズ名")
                            .font(.headline)
                            .frame(width: 80)
                        TextField("グッズを入力してください。", text: $goodsName)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                        Text("")
                            .frame(width: 30)
                    }
                    HStack {
                        Text("金額")
                            .font(.headline)
                            .frame(width: 80)
                        TextField("金額を入力してください。", text: $goodsPrice)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("円")
                            .font(.subheadline)
                            .frame(width: 30, alignment: .leading)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("キャンセル")
                            .foregroundStyle(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { //入力したデータを前のViewへ渡して保存を行う。
                        do {
                            let goods = try checkInputGoods(goodsName: goodsName,
                                                            goodsPrice: goodsPrice,
                                                            uiImage: selectedImage)
                            saveGoods(goods)
                            dismiss()
                        } catch let error as GoodsError {
                            errorText = error.localizedDescription
                            isError = true
                        } catch {
                            fatalError("#checkInputGoods unknown error.")
                        }
                    } label: {
                        Text("保存")
                    }
                    
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                PhotoPicker(selectedImage: $selectedImage)
            }
            .alert(errorText, isPresented: $isError) {
                Button("OK"){
                    isError = false
                }
            }
        }
    }
    
    private func checkInputGoods(goodsName: String, goodsPrice: String, uiImage: UIImage?) throws -> SaveGood {
        //グッズの名前をチェック。
        guard !goodsName.isEmpty else { throw GoodsError.emptyGoodsName }
        //グッズの金額をチェック。
        guard let goodsPrice = Int(goodsPrice) else { throw GoodsError.invalidPrice }
        //画像チェックし、nilの場合は『photo』の画像を含んだSaveGood型を返す。
        guard let uiImage = uiImage else {
            return SaveGood(name: goodsName, price: goodsPrice, uiImage: UIImage(systemName: "photo")!)
        }
        return SaveGood(name: goodsName, price: goodsPrice, uiImage: uiImage)
    }
    
}
