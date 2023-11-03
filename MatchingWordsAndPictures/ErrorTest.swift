//
//  ErrorTest.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/11/02.
//

import SwiftUI

enum ErrorHandling: LocalizedError {
    case parseError
    case emptyError
    case unknownError
    var typeString: String {
        switch self {
        case .parseError:
            return "数字じゃないです"
        case .emptyError:
            return "空です"
        case .unknownError:
            return "原因がわかりません"
        }
    }
}

struct ErrorTest: View {
    
    @State var numText = ""
    @State var errorType: ErrorHandling? = nil
    @State var num: Int? = nil
    @State var isError = false
    
    var body: some View {
        ZStack{
            Color.blue.ignoresSafeArea()
            VStack{
                TextField("", text: $numText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button("解析"){
                    do {
                        num =  try serchText(stringNum: numText)
                    } catch  {
                        isError = true
                        
                    }
                }
                .foregroundColor(.white)
                .padding()
                VStack{
                    if let num = num {
                        Text("数字は：\(num)です")
                    } else {
                        Text("数字なし")
                    }
                }
                .foregroundColor(.white)
                .padding()
            }
            .alert(isPresented: $isError, error: errorType) { _ in
                Button("承知"){
                    isError = false
                }
            } message: { error in

            }
        }
        
    }
    
    func serchText(stringNum: String) throws -> Int {
        guard stringNum.isEmpty == false else {
            print("🟥")
            throw ErrorHandling.emptyError
        }
        let numParse: (String) -> Int? = { str in Int(str) }
        guard let num = numParse(stringNum) else {
            print("🟦")
            throw ErrorHandling.parseError
        }
        return num
    }
    
}

struct ErrorTest_Previews: PreviewProvider {
    static var previews: some View {
        ErrorTest()
    }
}
