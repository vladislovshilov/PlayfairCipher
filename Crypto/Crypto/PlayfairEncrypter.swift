//
//  PlayfairEncrypter.swift
//  Crypto
//
//  Created by Vlados iOS on 5/21/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol Encrypter {
    func encrypt(_ word: String, with matrix: [Character]) -> Bigram
}

/// Playfair cypher rules
///
///  * * * * *      * * O * *       Z * * O *       * * * * *
///  * O Y R Z      * * B * *       * * * * *       * * * * *
///  * * * * *      * * * * *       * * * * *       Y O Z * R
///  * * * * *      * * R * *       R * * X *       * * * * *
///  * * * * *      * * Y * *       * * * * *       * * * * *
///
///  OR becomes YZ  OR  -> BY       OR  -> ZX       OR  -> YZ

final class PlayfairEncypter: PlayfairEnigma, Encrypter {
    func encrypt(_ word: String, with matrix: [Character]) -> Bigram {
        let bigram = BigramAdapter().wrapp(from: word)
        var encryptedBigram = Bigram()
        
        var index = 0
        bigram.forEach { bigramItem in
            let firstItemIndex = findFirstElementIndex(in: matrix, from: bigramItem)
            let secondItemIndex = findSecondElementIndex(in: matrix, from: bigramItem)
            
            print("---------")
            print("Indexes for \(index) bigram: \(bigramItem)")
            print(firstItemIndex)
            print(secondItemIndex)
            print("----------")
            
            let encryptedBigramItem = perform(.encryption, of: bigramItem, with: matrix, firstIndex: firstItemIndex, secondIndex: secondItemIndex)
            encryptedBigram.append(encryptedBigramItem)
            
            index += 1
        }
        
        return encryptedBigram
    }
}
