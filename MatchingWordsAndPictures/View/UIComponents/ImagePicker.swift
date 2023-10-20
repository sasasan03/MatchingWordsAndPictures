//
//  ImagePicker.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/23.
//

import Foundation
import SwiftUI

//UIViewControllerRepresentable : ViewControllerを作成・更新・破棄するためにそのメソッドを使用する。
//SwiftUIビューと協調させたい場合、それらの相互作用を促進するためにコーディネーターのインスタンスを提供する必要がある。
struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    enum SourceType {
        case camera
        case library
    }
    
    var sourceType: SourceType
    var allowsEditing: Bool = false
        
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.delegate = context.coordinator
        switch sourceType {
        case .camera:
            viewController.sourceType = UIImagePickerController.SourceType.camera
        case .library:
            viewController.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        viewController.allowsEditing = allowsEditing
        return viewController
    }

    
    //MARK: -
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.editedImage] as? UIImage {
                parent.image = image
            } else if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
