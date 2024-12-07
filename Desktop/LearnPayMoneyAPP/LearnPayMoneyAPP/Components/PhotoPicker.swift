//
//  PhotoPicker.swift
//  LearnPayMoneyAPP
//
//  Created by sako0602 on 2024/12/07.
//

import SwiftUI
import PhotosUI

// PHPickerViewControllerをSwiftUIで使えるようにラップ
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images  // 画像のみを表示
        configuration.selectionLimit = 1  // 1枚の画像を選択

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator  // デリゲート設定
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        // 画像が選択されたときに呼ばれる
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}
