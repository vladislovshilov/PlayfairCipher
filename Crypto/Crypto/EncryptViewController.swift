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
    }
    
}
