//
//  AGFormatter+Extension.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 30.10.2021.
//

import Foundation

extension AGFormatter {
    public var maskHasConstantPrefix: Bool {
        prefix.first(where: { "#?*".contains($0) }) == nil && !prefix.isEmpty
    }
    
    public func isNumberOrLetter(_ ch: Character?) -> Bool {
        guard let char = ch else { return false }
        return char.isNumber || char.isLetter
    }
    
    public var acceptedLetters: Set<Character> {
        .init()
    }
    
    public func isValidString(text: String?) -> Bool {
        guard let resultText = formattedText(text: text) else { return allowsEmptyOrNilStrings }
        return resultText.count == mask.count
    }
    
    public var allowsEmptyOrNilStrings: Bool {
        false
    }
    
    public func formattedText(text: String?) -> String? {
        defaultFormattedText(text: text)
    }
    
    public func defaultFormattedText(text: String?) -> String? {
        guard let t = text, !mask.isEmpty else { return text }

        var textRemovingSpecialSymbols = String(t.filter { isNumberOrLetter($0) })

        // insert prefix if its constant
        if maskHasConstantPrefix,
           !textRemovingSpecialSymbols.hasPrefix(prefix) {
            textRemovingSpecialSymbols.insert(
                contentsOf: prefix,
                at: textRemovingSpecialSymbols.startIndex
            )
        }
        
        var result = ""
        var index = maskHasConstantPrefix ?
        textRemovingSpecialSymbols.index(textRemovingSpecialSymbols.startIndex, offsetBy: prefix.count) :
        textRemovingSpecialSymbols.startIndex
        for ch in mask where index < textRemovingSpecialSymbols.endIndex {
            switch ch {
            case "*", "#", "?":
                while // trim 'bad' charachters
                    index < textRemovingSpecialSymbols.endIndex &&
                        (textRemovingSpecialSymbols[index].isNumber && ch == "*" ||
                         textRemovingSpecialSymbols[index].isLetter && ch == "#")
                {
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
        
        if textRemovingSpecialSymbols == prefix && maskHasConstantPrefix {
            return textRemovingSpecialSymbols.uppercased()
        }
        
        // consider string which contains only special symbols and spases invalid
        if result.filter({ $0.isLetter || $0.isNumber }).isEmpty {
            return nil
        }
        
        return result.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
