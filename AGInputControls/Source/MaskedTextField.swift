//
//  LettersFormatting.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 14.10.2021.
//

import UIKit

/// L - letter
/// D - digit
/// A- any (letter or digit)
open class MaskedTextField: FormattingTextField {
    
    open override func formattedText(text: String?) -> String? {
        guard let mask = formattingMask, let t = text, !t.isEmpty else { return text }

        var result = ""
        
        var isSymbolInserted = false
        var symbol: Character?
        
        for (idx, maskSymbol) in mask.enumerated() {
            
            let index = t.index(t.startIndex, offsetBy: idx)
            
            if idx == t.count {
                if !(maskSymbol.isLetter || maskSymbol.isNumber), !result.isEmpty, isSymbolInserted {
                    symbol = maskSymbol
                }
                break
            }
            
            let ch = t[index]
            
            switch maskSymbol {
            case "L":
                isSymbolInserted = ch.isLetter
                if ch.isLetter {
                    result.append(ch)
                }
            case "D":
                isSymbolInserted = ch.isNumber
                if ch.isNumber {
                    result.append(ch)
                }
            case "A":
                isSymbolInserted = ch.isNumber || ch.isLetter
                if ch.isNumber || ch.isLetter  {
                    result.append(ch)
                }
            default:
                result.append(maskSymbol)
                isSymbolInserted = true
            }
        }
        
        if let s = symbol,
           isSymbolInserted,
           mask[mask.index(mask.startIndex, offsetBy: result.count)] == s
        {
            result.append(s)
        }
        
        if exampleMask != nil {
            setNeedsDisplay()
        }
        
        return result.uppercased()
    }

    override func isValid(_ ch: Character?) -> Bool {
        guard let char = ch else { return false }
        return char.isNumber || char.isLetter
    }
}
