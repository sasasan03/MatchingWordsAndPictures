//
//  ErrorTest.swift
//  MatchingWordsAndPictures
//
//  Created by sako0602 on 2023/11/02.

import SwiftUI

enum TextError: LocalizedError {
    case parseError
    case emptyError
    case unknown
    var errorDescription: String? {
        switch self {
        case .parseError:
            return "数字を入力してください"
        case .emptyError:
            return "入力されていません"
        case .unknown:
            return "原因がわかりません"
        }
    }
}

struct ErrorTest: View {
    
    @State var numText = ""
    @State var errorType: TextError? = nil
    @State var num: Int? = nil
    @State var showError = false
    
    var body: some View {
        ZStack{
            Color.blue.ignoresSafeArea()
            VStack{
                TextField("", text: $numText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button("解析"){
                    do {
                        num =  try parseNumberFromString(numText: numText)
                    } catch let error as TextError {
                        showError = true
                        errorType = error
                    } catch {
                        showError = true
                        errorType = .unknown
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
            .alert(isPresented: $showError, error: errorType) {
                Button("承知"){
                    //...処理を記述
                }
            }
        }
        
    }
    
    func parseNumberFromString(numText: String) throws -> Int {
        guard !numText.isEmpty else {
            throw TextError.emptyError
        }
        let numParse: (String) -> Int? = { str in Int(str) }
        guard let num = numParse(numText) else {
            throw TextError.parseError
        }
        return num
    }
    
}

struct ErrorTest_Previews: PreviewProvider {
    static var previews: some View {
        ErrorTest()
    }
}
