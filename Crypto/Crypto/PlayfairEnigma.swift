//
//  PlayfairEnigma.swift
//  Crypto
//
//  Created by Vlados iOS on 5/23/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Foundation

class PlayfairEnigma {
    // MARK: - Support methods
    func findFirstElementIndex(in matrix: [Character], from bigramItem: [Character]) -> IndexPath {
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
    
    func findSecondElementIndex(in matrix: [Character], from bigramItem: [Character]) -> IndexPath {
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
    
    func perform(_ type: PlayfairType, of bigramItem: [Character], with matrix: [Character], firstIndex: IndexPath, secondIndex: IndexPath) -> [Character] {
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
            let firstMatrixIndex = getMatrixIndex(from: firstIndex, for: rule, with: type)
            let secondMatirxIndex = getMatrixIndex(from: secondIndex, for: rule, with: type)
            
            encryptedBigram[0] = matrix[firstMatrixIndex]
            encryptedBigram[1] = matrix[secondMatirxIndex]
            
        default:
            let indexes = getCrossIndexes(from: firstIndex, and: secondIndex)
            
            encryptedBigram[0] = matrix[indexes.first]
            encryptedBigram[1] = matrix[indexes.second]
        }
        
        return encryptedBigram
    }
    
    private func getMatrixIndex(from bigramIndex: IndexPath, for rule: PlayfairRule, with type: PlayfairType) -> Int {
        switch rule {
        case .section:
            if bigramIndex.item == type.rowMaximum {
                switch type {
                case .encryption:
                    return bigramIndex.section * 5
                case .decryption:
                    return bigramIndex.section * 5 + 4
                }
            }
            else {
                return (bigramIndex.item + type.rowAddition) + bigramIndex.section * 5
            }
        case .row:
            if bigramIndex.section == type.rowMaximum {
                switch type {
                case .encryption:
                    return bigramIndex.item
                case .decryption:
                    return 25 - bigramIndex.item
                }
            }
            else {
                return (bigramIndex.section + type.rowAddition) * 5 + bigramIndex.item
            }
        case .cross: return bigramIndex.section * 5 + bigramIndex.item
        }
    }
    
    func getCrossIndexes(from firstBigramIndex: IndexPath, and secondBigramIndex: IndexPath) -> (first: Int, second: Int) {
        let firstIndexPath = IndexPath(item: secondBigramIndex.item, section: firstBigramIndex.section)
        let secondIndexPath = IndexPath(item: firstBigramIndex.item, section: secondBigramIndex.section)
        
        let firstIndex = getMatrixIndex(from: firstIndexPath, for: .cross, with: .encryption)
        let secondIndex = getMatrixIndex(from: secondIndexPath, for: .cross, with: .encryption)
        
        return (first: firstIndex, second: secondIndex)
    }
}
