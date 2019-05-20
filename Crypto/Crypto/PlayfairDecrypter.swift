//
//  PlayfairDecrypter.swift
//  Crypto
//
//  Created by Vlados iOS on 5/21/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol Decrypter {
    func decrypt(_ string: String, with password: String) -> String 
}

final class PlayfairDecrypter: Decrypter {
    func decrypt(_ string: String, with password: String) -> String {
        return ""
    }
}
