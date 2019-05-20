//
//  BigramAdapter.swift
//  Crypto
//
//  Created by Vlados iOS on 5/21/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol Adapter {
    associatedtype FromValue
    associatedtype ToValue
    
    func wrapp(from value: FromValue) -> ToValue
    func unwrapp(from value: ToValue) -> FromValue
}

final class BigramAdapter: Adapter {
    typealias FromValue = String
    typealias ToValue = Bigram
    
    func wrapp(from value: String) -> Bigram {
        return createBigram(from: getInitialCharacterSet(from: value))
    }
    
    func unwrapp(from value: Bigram) -> String {
        return ""
    }
    
    // MARK: - Support methods
    private func getInitialCharacterSet(from string: String) -> [Character] {
        var set = [Character]()
        
        string.uppercased().forEach { ch in
            if !ch.isWhitespace {
                set.append(ch)
            }
        }
        
        return set
    }
    
    private func createBigram(from characterSet: [Character]) -> Bigram {
        var bigram = Bigram()
        
        var bigramIndex = 0
        var elementIndex = 0
        characterSet.forEach { ch in
            if elementIndex == 0 {
                let newElement = [ch, " "]
                bigram.append(newElement)
                
                elementIndex += 1
                
                if bigramIndex + 1 > bigram.count / 2 {
                    bigram[bigramIndex][elementIndex] = "X"
                    return
                }
            }
            else if bigram[bigramIndex][elementIndex - 1] == ch {
                bigram[bigramIndex][elementIndex] = "X"
                
                let newElement = [ch, " "]
                bigram.append(newElement)
                
                bigramIndex += 1
                elementIndex = 1
            }
            else {
                bigram[bigramIndex][elementIndex] = ch
                
                bigramIndex += 1
                elementIndex = 0
            }
            
//            bigramIndex += elementIndex == 1 ? 1 : 0
//            elementIndex = elementIndex == 1 ? 0 : 1
        }
        
        return bigram
    }
}
