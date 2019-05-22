//
//  PlayfairEncrypter.swift
//  Crypto
//
//  Created by Vlados iOS on 5/21/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Foundation

enum PlayfairRule {
    case row, section, cross
}

enum PlayfairType {
    case encryption, decryption
    
    var rowAddition: Int {
        switch self {
        case .encryption:
            return 1
        case .decryption:
            return -1
        }
    }
    
    var rowMaximum: Int {
        switch self {
        case .encryption:
            return 4
        case .decryption:
            return 0
        }
    }
}

protocol Encrypter {
    func encrypt(_ bigram: Bigram, with matrix: [Character]) -> Bigram
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
    func encrypt(_ bigram: Bigram, with matrix: [Character]) -> Bigram {
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
