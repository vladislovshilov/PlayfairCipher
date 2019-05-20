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
        bigramAdapter.wrapp(from: "IDIOCY OFTEN LOOKS LIKE INTELLIGENCE")
    }
    
}
