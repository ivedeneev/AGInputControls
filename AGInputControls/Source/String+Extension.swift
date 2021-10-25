//
//  String+Extension.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 25.10.2021.
//

import Foundation

extension String {
    func formattedNumber(mask: String) -> String {
        let rawPhone = digitsOnly()

        var result = ""
        var index = rawPhone.startIndex
        for ch in mask where index < rawPhone.endIndex {
            if ch == "X" || ch.isNumber {
                result.append(rawPhone[index])
                index = rawPhone.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func digitsOnly() -> String {
        components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    func alphanumericsOnly() -> String {
        components(separatedBy: CharacterSet.alphanumerics.inverted).joined(separator: "")
    }
    
    func alphanumeric() -> String {
        components(separatedBy: CharacterSet.letters.inverted).joined()
    }
}
