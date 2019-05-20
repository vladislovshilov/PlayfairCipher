//
//  PlayfairEncrypter.swift
//  Crypto
//
//  Created by Vlados iOS on 5/21/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol Encrypter {
    func encrypt(_ bigram: Bigram, with matrix: [Character]) -> String
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
    func encrypt(_ bigram: Bigram, with matrix: [Character]) -> String {
        return ""
    }
}
