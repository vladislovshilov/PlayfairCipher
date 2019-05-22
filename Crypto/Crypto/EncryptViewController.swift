//
//  EncryptViewController.swift
//  Crypto
//
//  Created by Vlados iOS on 5/21/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Cocoa

class EncryptViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bigramAdapter = BigramAdapter()
        let bigram = bigramAdapter.wrapp(from: "Hello world")
        let string = bigramAdapter.unwrapp(from: bigram)
        
        print("Wrapper result: \n")
        print(bigram)
        print(string)
        print("-------------------")
        
        let matrixService = MatrixService()
        matrixService.password = "hello"
        let matrix = matrixService.getMatrix()
        
        let encrypter = PlayfairEncypter()
        let encryptedString = encrypter.encrypt("Hello world", with: matrix)
        
        print("Encrypter result:")
        print(encryptedString)
        print("------------------")
        
        let decrypter = PlayfairDecrypter()
        let decryptedString = decrypter.decrypt(encryptedString, with: matrix)
        
        print("Decrypted result:")
        print(decryptedString)
        print("------------------")
    }
    
}
