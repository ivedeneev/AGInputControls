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
        guard let mask = formattingMask, let t = text else { return text }

        var textRemovingSpecialSymbols = String(t.filter { isValidCharachter($0) })

        var result = ""
        var index = textRemovingSpecialSymbols.startIndex

        for ch in mask where index < textRemovingSpecialSymbols.endIndex {
            let symbolToValidate = textRemovingSpecialSymbols[index]
            switch ch {
            case "L", "D", "A":
                if symbolToValidate.isNumber && ch == "L" || symbolToValidate.isLetter && ch == "D" {
                    textRemovingSpecialSymbols.remove(at: index)
                }
                //double check if we are not out of bounds, because we manupulate with string length inside
                if index >= textRemovingSpecialSymbols.endIndex {
                    break
                }
                
                result.append(textRemovingSpecialSymbols[index])
                index = textRemovingSpecialSymbols.index(after: index)
            default:
                result.append(ch)
            }
        }
        
        if exampleMask != nil {
            setNeedsDisplay()
        }
        
        // consider string which contains only special symbols and spases invalid
        if result.filter({ $0.isLetter || $0.isNumber }).isEmpty {
            return nil
        }
        
        return result.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }

    open override func isValidCharachter(_ ch: Character?) -> Bool {
        guard let char = ch else { return false }
        return char.isNumber || char.isLetter
    }
}
