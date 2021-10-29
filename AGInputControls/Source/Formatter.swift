//
//  File.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 28.10.2021.
//

import Foundation

public protocol Formatter {
    var mask: String { get }
    var maskHasConstantPrefix: Bool { get }
    var prefix: String { get }
    var allowsEmptyOrNilStrings: Bool { get }
    
    func formattedText(text: String?) -> String?
    func isValidCharachter(_ ch: Character?) -> Bool
    func isValidString(text: String?) -> Bool
}

extension Formatter {
    public var maskHasConstantPrefix: Bool {
        prefix.first(where: { "#?*".contains($0) }) == nil && !prefix.isEmpty
    }
    
    public func isValidCharachter(_ ch: Character?) -> Bool {
        guard let char = ch else { return false }
        return char.isNumber || char.isLetter
    }
    
    
    public func isValidString(text: String?) -> Bool {
        guard let resultText = formattedText(text: text) else { return allowsEmptyOrNilStrings }
        return resultText.count == mask.count
    }
    
    public var allowsEmptyOrNilStrings: Bool {
        false
    }
}
