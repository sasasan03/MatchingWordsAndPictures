import UIKit

struct Person: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var uiImage: UIImage?
}

//let sako = Person(name: "sako")
//let mako = Person(name: "mako")
//print(sako.id == mako.id)

var persons:[Person] = []

func personNameAdd(name: String){
    persons.append(Person(name: name))
}

func personImageAdd(imageName: String, index: Int ){
    persons[index].uiImage = UIImage(named: imageName)
}

personNameAdd(name: "さこ")
personImageAdd(imageName: "佐小田の写真", index: 0)
print(persons[0].name)

//if let 
//
//print(persons[0].uiImage)



//-----------------------------------------------------   Data -> String
//struct Person {
////    var nameAndImage: (String, UIImage?)
//    var name: String
//    var image: UIImage?
//}
//
//var persons: [Person] = [
////    Person(nameAndImage: ("sako", UIImage(named: "hiro"))),
////    Person(nameAndImage: ("echi", UIImage(named: "mako")))
//    Person(name: "sako")
//]
//
//
//
//🟥UIImageをStringへ
//struct Person {
//    var name: String
//    var imageString: String?
//
//    // UIImageをString（Base64）に変換するメソッド
//    init(name: String, image: UIImage?) {
//        self.name = name
//        if let img = image {
//            self.imageString = img.toBase64()
//        }
//    }
//
//    // UIImageにアクセスするためのプロパティ
//    var uiImage: UIImage? {
//        if let imgString = imageString {
//            return UIImage(base64: imgString)
//        }
//        return nil
//    }
//}
//
//extension UIImage {
//    func toBase64() -> String? {
//        return self.jpegData(compressionQuality: 1.0)?.base64EncodedString()
//    }
//}

//extension UIImage {
//    convenience init?(base64: String) {
//        guard let data = Data(base64Encoded: base64) else {
//            return nil
//        }
//        self.init(data: data)
//    }
//}
//
//let sako = Person(name: "sako", image: UIImage(base64: "hiro"))
//print(sako.imageString)
