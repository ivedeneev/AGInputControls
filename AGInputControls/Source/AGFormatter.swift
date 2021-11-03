//
//  File.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 28.10.2021.
//

import Foundation

public protocol AGFormatter {
    var mask: String { get }
    var maskHasConstantPrefix: Bool { get }
    var prefix: String { get }
    var allowsEmptyOrNilStrings: Bool { get }
    var acceptedLetters: Set<Character> { get }
    
    func formattedText(text: String?) -> String?
    func isNumberOrLetter(_ ch: Character?) -> Bool
    func isValidString(text: String?) -> Bool
}
