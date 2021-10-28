//
//  DefaultFormatter.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 28.10.2021.
//

import Foundation

public struct DefaultFormatter: Formatter {
    public var mask: String
    
    public var prefix: String {
        guard let separator = mask.first(where: { !("#?*".contains($0) || $0.isLetter || $0.isNumber) }) else { return "" }
        
        return mask.components(separatedBy: String(separator)).first ?? ""
    }
    
    public func formattedText(text: String?) -> String? {
        guard let t = text else { return text }

        var textRemovingSpecialSymbols = String(t.filter { isValidCharachter($0) })

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
