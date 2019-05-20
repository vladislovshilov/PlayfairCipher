//
//  MatrixService.swift
//  Crypto
//
//  Created by Vlados iOS on 5/21/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol IMatrixService {
    var password: String { get set }
    
    func generateMatrix()
    func getMatrix() -> [Character]
    func generatePassword() -> String
}

final class MatrixService: IMatrixService {
    var password = ""
    
    private let randomWords = ["random", "password", "oleg", "word"]
    
    private var matrix = [Character] ()
    
    init() {
        generateMatrix(with: password)
    }
    
    func generateMatrix() {
        generateMatrix(with: password)
    }
    
    func getMatrix() -> [Character] {
        return matrix
    }
    
    func generatePassword() -> String {
        let random = UInt32(randomWords.count - 1)
        let index = Int(arc4random_uniform(random))
        password = randomWords[index]
        
        return password
    }
}

// MARK: - Support methods

extension MatrixService {
    private func generateMatrix(with password: String) {
        matrix.removeAll()
        password.uppercased().forEach { ch in
            if !matrix.contains(ch), ch != "Q", !ch.isNumber {
                matrix.append(ch)
            }
        }
        
        let startChar = Unicode.Scalar("A").value
        let endChar = Unicode.Scalar("Z").value
        
        for alphabet in startChar...endChar {
            if let scalar = Unicode.Scalar(alphabet), !password.uppercased().contains(Character(scalar)), Character(scalar) != "Q" {
                self.matrix.append(Character(scalar))
            }
        }
        print(matrix)
    }
}
