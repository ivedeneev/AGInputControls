//
//  PhoneNumberFormatter.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 28.10.2021.
//

import Foundation

public struct PhoneNumberFormatter: AGFormatter {
    
    public let mask: String
    
    public var prefix: String {
        guard let separator = mask.first(
            where: { !($0.isNumber || $0 == "+" || $0 == "#") }
        ) else {
            return ""
        }
        
        return mask.components(separatedBy: String(separator)).first ?? ""
    }
    
    public init(mask: String) {
        self.mask = mask
    }
    
    public func formattedText(text: String?) -> String? {
        guard var t = text?.trimmingCharacters(in: .whitespacesAndNewlines),
              t != "+",
              !t.isEmpty
        else { return "" }
        
        if t == prefix && maskHasConstantPrefix {
            return nil
        }
        
        // Special case for Russian numbers. if we paste number in old format (e.g 89997776655) we conver it in international format (replace 8 with +7)
        if prefix == "+7" && (t.first == "8" || t.first == "7") && t.count >= 11 {
            t = prefix + t.dropFirst()
        }

        if maskHasConstantPrefix && !t.hasPrefix(prefix) {
            t = prefix + t
        }

        let formatted = t.formattedNumber(mask: mask)

        return formatted
    }
}
