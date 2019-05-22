//
//  PlayfairDecrypter.swift
//  Crypto
//
//  Created by Vlados iOS on 5/21/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol Decrypter {
    func decrypt(_ bigram: Bigram, with matrix: [Character]) -> String
}

final class PlayfairDecrypter: PlayfairEnigma, Decrypter {
    func decrypt(_ bigram: Bigram, with matrix: [Character]) -> String {
        let adapter = BigramAdapter()
        var decryptedBigram = Bigram()
        
        var index = 0
        bigram.forEach { bigramItem in
            let firstItemIndex = findFirstElementIndex(in: matrix, from: bigramItem)
            let secondItemIndex = findSecondElementIndex(in: matrix, from: bigramItem)
            
            print("---------")
            print("Indexes for \(index) bigram: \(bigramItem)")
            print(firstItemIndex)
            print(secondItemIndex)
            print("----------")
            
            let decryptedBigramItem = perform(.decryption, of: bigramItem, with: matrix, firstIndex: firstItemIndex, secondIndex: secondItemIndex)
            decryptedBigram.append(decryptedBigramItem)
            
            index += 1
        }
        
        return adapter.unwrapp(from: decryptedBigram)
    }
}
