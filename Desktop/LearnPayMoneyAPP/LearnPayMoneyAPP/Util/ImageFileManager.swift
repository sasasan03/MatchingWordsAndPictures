//
//  ImageFileManager.swift
//  LearnPayMoneyAPP
//
//  Created by sako0602 on 2024/12/07.
//

import Foundation
import UIKit

//TODO: パスが重複してしまうと、書き込み取り出しができなくなるのでバリデーション処理を追加する
struct ImageFileManager {
    
    let fileManager = FileManager.default
    
    // ショップの画像操作------------------------------------------------------
    /// shopのディレクトリのパスを取得
    /// Viewの中で、Shop型で保存するためString。
    func shopURL(shopName: String) throws -> String {
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw ImageFileManagerError.documentURLNotFound
        }
        let shopDirectoryURL = documentURL.appendingPathComponent("\(shopName)")
        
        return shopDirectoryURL.absoluteString
    }
    
    ///　ショップの画像書き込み
    func saveShopImage(shopName: String,uiImage: UIImage) {
        
        do {
            guard let shopURL = URL(string: try shopURL(shopName: shopName)) else { throw ImageFileManagerError.shopURLNotFound }
            //ディレクトリがなければディレクトリを作成する
            if !fileManager.fileExists(atPath: shopURL.path) {
                try fileManager.createDirectory(at: shopURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            }
            guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else { throw ImageFileManagerError.imageCreationFailed }
            //拡張子をjpegにしてPathを作る
            let shopImagePath = shopURL.appendingPathComponent("\(shopName).jpeg")
            //書き込む
            try imageData.write(to: shopImagePath)
        } catch {
            print("#### error", error.localizedDescription)
        }
        

    }
    
    /// ショップの写真をアプリから削除する
    func deleteShopImage(shopName: String) {
        do {
            guard let shopURL = URL(string: try shopURL(shopName: shopName)) else { throw ImageFileManagerError.shopURLNotFound }
            // 保存してある、ファイルごと消去する
            try fileManager.removeItem(at: shopURL)
            
        } catch {
            print("####error",error.localizedDescription)
        }
    }
    
    /// ショップの画像読みこみ。UIImageを返す
    func loadShopImage(shopName: String) -> UIImage {
        
        do {
            guard let shopURL = URL(string: try shopURL(shopName: shopName)) else { throw ImageFileManagerError.shopURLNotFound }
            
            let shopImagePath = shopURL.appendingPathComponent("\(shopName).jpeg")
            
            let imageData = try Data(contentsOf: shopImagePath)
            
            guard let uiImage = UIImage(data: imageData) else { throw ImageFileManagerError.dataConversionFailed }
            
            return uiImage
        } catch {
            // 画像の変換が失敗した時に返すデフォルトの画像
            return UIImage(systemName: "photo")!
        }
    }
    
    //グッズの画像操作----------------------------------------------------------------------------
    /// グッズのパスを作成する
    func goodsURL(shopName: String, goodsName: String) throws -> String {
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw ImageFileManagerError.documentURLNotFound
        }
        let shopDirectoryURL = documentURL.appendingPathComponent("\(shopName)")
        
        let goodDirectoryURL = shopDirectoryURL.appendingPathComponent("\(goodsName)")

        return goodDirectoryURL.absoluteString
    }
    /// グッズの書き込みを行う。もしも、保存先のディレクトリがない場合は作成して書き込みを行う。
    /// パスのStringを返す。
    func saveGoodsImage(shopName: String, goodsName: String, uiImage: UIImage) -> String {
        
        do {
            guard let goodsURL = URL(string: try goodsURL(shopName: shopName, goodsName: goodsName)) else {
                throw ImageFileManagerError.invalidFilePath
            }
            //ディレクトリがなければディレクトリを作成する
            if !fileManager.fileExists(atPath: goodsURL.path) {
                try fileManager.createDirectory(at: goodsURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            }
            guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else {
                throw ImageFileManagerError.imageCreationFailed
            }
            //拡張子をjpegにしてPathを作る
            let goodsImagePath = goodsURL.appendingPathComponent("\(goodsName).jpeg")
            //書き込む
            try imageData.write(to: goodsImagePath)
            
            return goodsImagePath.absoluteString
        } catch {
            print("エラー: \(error)")
            return "no exit file path."
        }
    }
    
    /// ショップの画像読みこみ。UIImageを返す
    func loadGoodsImage(shopName: String,goodsName: String) -> UIImage {
        //documentURLを取得する
        do {
            guard let goodsURL = URL(string: try goodsURL(shopName: shopName, goodsName: goodsName)) else {
                throw ImageFileManagerError.goodsURLNotFound
            }
            
            let goodsImagePath = goodsURL.appendingPathComponent("\(goodsName).jpeg")
            
            let imageData = try Data(contentsOf: goodsImagePath)

            guard let uiImage = UIImage(data: imageData) else {
                throw ImageFileManagerError.imageCreationFailed
            }
            
            return uiImage
        } catch {
            return UIImage(systemName: "photo")!
        }
    }
    
    func deleteGoodsImage(shopName: String, goodsName: String) {
        do {
            guard let goodsURL = URL(string: try goodsURL(shopName: shopName, goodsName: goodsName)) else {
                throw ImageFileManagerError.invalidFilePath
            }
            try fileManager.removeItem(at: goodsURL)//フォルダを削除
            //画像の削除
            //            let goodsImagePath = goodsURL.appendingPathComponent("\(goodsName).jpeg")
            //            try fileManager.removeItem(at: goodsImagePath)//写真を削除
        } catch {
            print("#goodsのPathの削除に失敗しました。", error.localizedDescription)
        }
    }

}

