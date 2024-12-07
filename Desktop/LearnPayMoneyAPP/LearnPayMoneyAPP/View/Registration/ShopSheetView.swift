//
//  ShopSheetView.swift
//  LearnPayMoneyAPP
//
//  Created by sako0602 on 2024/12/07.
//

import SwiftUI

struct ShopSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var shopName = ""
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    @State private var isError = false
    @State private var shouldConfirmDeletion = false
    let imageFileManager = ImageFileManager()
    let saveShopData: (String, UIImage) -> Void
    
    var body: some View {
        NavigationStack {
            VStack{
                //画像が選ばれたときと、選ばれなかった時のパターンを考えたかった。
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                            .frame(width: 200, height: 200)
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    } else {
                        Image(systemName: "photo.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                            .frame(width: 200, height: 200)
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    }
                TextField("お店の名前を入力してください。", text: $shopName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // もしも、写真が選ばれたら、その写真を保存し、選ばれなかった場合はデフォルトの画像を用意する。
                    Button("追加"){
                        do {
                            try checkShopName(shopName: shopName)
                        } catch {
                            isError = true
                            return print("#checkShopName error.")// returnしてモーダルを閉じさせ、GoodsViewへ遷移させない。
                        }
                        if let selectedImage {
                            saveShopData(shopName,selectedImage)
                        } else {
                            let photoImage = UIImage(systemName: "photo")!//確実に存在する画像
                            saveShopData(shopName, photoImage)
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        confirmDelete(shopName: shopName)
                    } label: {
                        Text("キャンセル")
                            .foregroundStyle(.red)
                    }
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                PhotoPicker(selectedImage: $selectedImage)
            }
            .alert(isPresented: $isError, error: ShopError.emptyShopName) {
                Button("了解"){
                    isError = false
                }
            }
            .alert("変更は保存されませんがよろしいですか？", isPresented: $shouldConfirmDeletion) {
                HStack {
                    Button("はい"){
                        dismiss()
                    }
                    Button("いいえ"){
                        return
                    }
                }
            }
        }
    }
    
    private func checkShopName(shopName: String) throws {
        guard !shopName.isEmpty else {
            throw ShopError.emptyShopName
        }
    }
    
    /// 入力情報を破棄するかどうかの確認を行う。
    private func confirmDelete(shopName: String){
        if !shopName.isEmpty { //ショップの名前が入力されていなければアラートを表示させる
            shouldConfirmDeletion = true
        } else { //ショップの名前が入力されていた場合は閉じる
            dismiss()
        }
    }
    
}



//#Preview {
//    AddShopSheetView(saveShopData: (String, Data) -> Void)
//}
