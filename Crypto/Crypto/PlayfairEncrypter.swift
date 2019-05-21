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

final class PlayfairEncypter: Encrypter {
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
            
            let encryptedBigramItem = performEncrypting(of: bigramItem, with: matrix, firstIndex: firstItemIndex, secondIndex: secondItemIndex)
            encryptedBigram.append(encryptedBigramItem)
            
            index += 1
        }
        
        return encryptedBigram
    }
    
    // MARK: - Support methods
    private func findFirstElementIndex(in matrix: [Character], from bigramItem: [Character]) -> IndexPath {
        var indexPath = IndexPath(item: 0, section: 0)
        var shouldStop = false
        matrix.forEach({ ch in
            if ch == bigramItem.first! { shouldStop = true }
            else if !shouldStop {
                indexPath.item += 1
                if indexPath.item == 5 {
                    indexPath.item = 0
                    indexPath.section += 1
                }
            }
        })
        
        return indexPath
    }
    
    private func findSecondElementIndex(in matrix: [Character], from bigramItem: [Character]) -> IndexPath {
        var indexPath = IndexPath(item: 0, section: 0)
        var shouldStop = false
        matrix.forEach({ ch in
            if ch == bigramItem[1] { shouldStop = true }
            else if !shouldStop {
                indexPath.item += 1
                if indexPath.item == 5 {
                    indexPath.item = 0
                    indexPath.section += 1
                }
            }
        })
        
        return indexPath
    }
    
    private func performEncrypting(of bigramItem: [Character], with matrix: [Character], firstIndex: IndexPath, secondIndex: IndexPath) -> [Character] {
        var encryptedBigram = bigramItem
        var rule: PlayfairRule!
        
        if firstIndex.section == secondIndex.section {
            rule = .section
        }
        else if firstIndex.item == secondIndex.item {
            rule = .row
        }
        else {
            rule = .cross
        }
        
        switch rule! {
        case .section, .row:
            let firstMatrixIndex = getMatrixIndex(from: firstIndex, for: rule)
            let secondMatirxIndex = getMatrixIndex(from: secondIndex, for: rule)
            
            if firstMatrixIndex > secondMatirxIndex {
                encryptedBigram[0] = matrix[firstMatrixIndex]
                encryptedBigram[1] = matrix[secondMatirxIndex]
            }
            else {
                encryptedBigram[1] = matrix[firstMatrixIndex]
                encryptedBigram[0] = matrix[secondMatirxIndex]
            }
            
        default:
            let indexes = getCrossIndexes(from: firstIndex, and: secondIndex)
            
            encryptedBigram[0] = matrix[indexes.first]
            encryptedBigram[1] = matrix[indexes.second]
        }
        
        return encryptedBigram
    }
    
    private func getMatrixIndex(from bigramIndex: IndexPath, for rule: PlayfairRule) -> Int {
        switch rule {
        case .section:
            if bigramIndex.item == 4 {
                return bigramIndex.section * 5
            }
            else {
                return (bigramIndex.item + 1) + bigramIndex.section * 5
            }
        case .row:
            if bigramIndex.section == 4 {
                return bigramIndex.item
            }
            else {
                return (bigramIndex.section + 1) * 5 + bigramIndex.item
            }
        case .cross: return bigramIndex.section * 5 + bigramIndex.item
        }
    }
    
    func getCrossIndexes(from firstBigramIndex: IndexPath, and secondBigramIndex: IndexPath) -> (first: Int, second: Int) {
        let firstIndexPath = IndexPath(item: secondBigramIndex.item, section: firstBigramIndex.section)
        let secondIndexPath = IndexPath(item: firstBigramIndex.item, section: secondBigramIndex.section)
        
        let firstIndex = getMatrixIndex(from: firstIndexPath, for: .cross)
        let secondIndex = getMatrixIndex(from: secondIndexPath, for: .cross)
        
        if firstIndexPath.section < secondIndexPath.section {
            return (first: firstIndex, second: secondIndex)
        }
        return (first: secondIndex, second: firstIndex)
    }
}
