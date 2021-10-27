//
//  FormattingTextField+Extension.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 25.10.2021.
//

import UIKit

extension FormattingTextField {
    
    internal func setCursorPosition(offset: Int) {
        guard let newPosition = position(from: beginningOfDocument, in: .right, offset: offset) else {return }
        selectedTextRange = textRange(from: newPosition, to: newPosition)
    }
    
    /// Caret position in int value
    internal func currentPosition() -> Int {
        guard let range = selectedTextRange else { return 0 }
        return offset(from: beginningOfDocument, to: range.end)
    }
    
    internal func sizeOfText(_ text: String) -> CGSize {
        return (text as NSString).boundingRect(
            with: UIScreen.main.bounds.size,
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [.font : font],
            context: nil).size
    }
    
    internal func assertForExampleMasksAndPrefix() {
        guard let mask = exampleMask, formattingMask != nil else { return }
        assert(mask == formattedText(text: mask), "Formatting mask and example mask should be in same format. This is your responsibility as a developer")
        assert(prefix.first(where: { $0.isLetter || $0.isNumber }) == nil || hasConstantPrefix, "You cannot have 'semi constant' prefixes at this point ")
    }
}
