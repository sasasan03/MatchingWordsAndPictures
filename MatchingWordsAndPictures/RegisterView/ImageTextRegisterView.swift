//
//  ImageTextRegisterView.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/09/06.
//

import SwiftUI

struct ImageTextRegisterView: View {
    
    @State private var rows: [ImageText] = Array(repeating: ImageText(), count: 4)
    
    @State var showingPicker = false
    @State var image: UIImage?
    @State var text = ""
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack{
                Color.green.ignoresSafeArea(.all)
                
                VStack{
                    Spacer()
                    ForEach(0..<rows.count, id: \.self){ index in
                        ImageTextRegisterRowView(text: $rows[index].text, uiImage: $rows[index].image)
                    }
                    Spacer()
                }
            }
        }
    }
}

//MARK: -

//UIViewControllerRepresentable : ViewControllerを作成・更新・破棄するためにそのメソッドを使用する。
//SwiftUIビューと協調させたい場合、それらの相互作用を促進するためにコーディネーターのインスタンスを提供する必要がある。
struct ImagePickerView: UIViewControllerRepresentable {
    
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
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
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



struct ImageTextRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTextRegisterView()
    }
}
