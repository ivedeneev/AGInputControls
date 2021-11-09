//
//  DefaultFormatter.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 28.10.2021.
//

import Foundation

public struct DefaultFormatter: AGFormatter {
    
    public var acceptedLetters: Set<Character>
    public let mask: String
    public let allowsEmptyOrNilStrings: Bool
    
    public init(
        mask: String,
        allowsEmptyOrNilStrings: Bool = false,
        acceptedLetters: Set<Character> = .init()
    ) {
        self.mask = mask
        self.allowsEmptyOrNilStrings = allowsEmptyOrNilStrings
        self.acceptedLetters = acceptedLetters
    }
}
