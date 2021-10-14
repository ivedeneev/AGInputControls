//
//  LettersFormatting.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 14.10.2021.
//

import UIKit

// L - letter
// D - digit
// A- any (letter or digit)
open class MaskedTextField: FormattingTextField {
    
    open override func formattedText(text: String?) -> String? {
        guard let mask = formattingMask, let t = text, !t.isEmpty else { return text }

        var result = ""
        if exampleMask != nil {
            setNeedsDisplay()
        }
        
        for  (idx, maskSymbol) in mask.enumerated() {
            let index = t.index(t.startIndex, offsetBy: idx)
            if idx == t.count {
                if !(maskSymbol.isLetter || maskSymbol.isNumber), !result.isEmpty {
                    result.append(maskSymbol)
                }
                break
            }
            let ch = t[index]
            switch maskSymbol {
            case "L":
                if ch.isLetter {
                    result.append(ch)
                }
            case "D":
                if ch.isNumber {
                    result.append(ch)
                }
            case "A":
                if ch.isNumber || ch.isLetter  {
                    result.append(ch)
                }
            default:
                result.append(maskSymbol)
            }
        }
        return result.uppercased()
    }

    override func isValid(_ ch: Character?) -> Bool {
        guard let char = ch else { return false }
        return char.isNumber || char.isLetter
    }
}
