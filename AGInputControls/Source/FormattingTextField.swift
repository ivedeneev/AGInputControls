//
//  FormattingTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 8/16/21.
//

import UIKit

open class FormattingTextField: UITextField {
    /// Formatting mask. Example: `+X (XXX) XXX-XX-XX` where X is any digit.If mask is not specified textfield acts like normal UITextField. Default is nil
    open var formattingMask: String?
    
    ///  Mask to be draw as example. Default is nit and no example mask is drawn. Placeholder is ignored if exaplmeMask is non null
    open var exampleMask: String?
    
    /// Color of placeholder. Default is `UIColor.lightGray`
    open var placeholderColor: UIColor = .lightGray
    
    internal var showsMask: Bool { exampleMask != nil }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        registerTextListener()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        registerTextListener()
    }
    
    private func registerTextListener() {
        addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
    }
    
    @objc internal func didChangeEditing() {
        var pos = currentPosition()
        let textCount = text!.count
        
        self.text = formattedText(text: text)
        
        guard let last = text!.prefix(pos).last else { return }
        if !"0123456789".contains(last) {
            pos = pos + 1 // не 1, а количество элементов до первой цифры с конца
        }
        if pos < textCount {
            setCursorPosition(offset: pos)
        }
    }
    
    open func formattedText(text: String?) -> String? {
        guard let mask = formattingMask, let t = text else { return text }

        let textRemovingAllButDigits = t.digitsOnly()

        var result = ""
        var index = textRemovingAllButDigits.startIndex
        for ch in mask where index < textRemovingAllButDigits.endIndex {
            if ch == "X" {
                result.append(textRemovingAllButDigits[index])
                index = textRemovingAllButDigits.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawExampleMask(rect: rect)
    }
    
    open func drawExampleMask(rect: CGRect) {
        guard let mask = exampleMask else { return }
        let text = self.text ?? ""
        
        let phone = text + mask.suffix(mask.count - text.count)
        let textToDraw = NSMutableAttributedString(string: phone, attributes: [
            .font : font,
            .foregroundColor : placeholderColor
        ])
        
        textToDraw.draw(at: CGPoint(x: 0, y: ((bounds.height - font!.lineHeight) / 2).rounded()))
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard !showsMask else { return .zero }
        return super.placeholderRect(forBounds: bounds)
    }
    
    
    open func setFormattedText(_ text: String) {
        self.text = formattedText(text: text)
    }
    
    open override func deleteBackward() {
        guard let range = selectedTextRange, var txt = self.text, !txt.isEmpty, selectedTextRange?.start != endOfDocument else {
            super.deleteBackward()
            return
        }
        
        let cursorPosition = offset(from: beginningOfDocument, to: range.start)
        
        if !isDigit(txt.prefix(cursorPosition).last) {
            var charsToRemove = 0
            while !isDigit(txt.prefix(cursorPosition - charsToRemove).last) {
                charsToRemove += 1
                txt.remove(at: .init(utf16Offset: cursorPosition - charsToRemove, in: txt))
            }
            
            charsToRemove += 1
            txt.remove(at: .init(utf16Offset: cursorPosition - charsToRemove, in: txt))

            setFormattedText(txt)
            setCursorPosition(offset: cursorPosition - charsToRemove)
            return
        }
        
        super.deleteBackward()
        setCursorPosition(offset: cursorPosition - 1)
    }
    
    internal func isDigit(_ ch: Character?) -> Bool {
        guard let char = ch else { return false }
        return "0123456789".contains(char)
    }
}

extension FormattingTextField {
    
    internal func setCursorPosition(offset: Int) {
        guard let newPosition = position(from: beginningOfDocument, in: .right, offset: offset) else {return }
        selectedTextRange = textRange(from: newPosition, to: newPosition)
    }
    
    internal func currentPosition() -> Int {
        guard let range = selectedTextRange else { return 0 }
        return offset(from: beginningOfDocument, to: range.start)
    }
    
    internal func sizeOfText(_ text: String) -> CGSize {
        return (text as NSString).boundingRect(
            with: UIScreen.main.bounds.size,
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [.font : font],
            context: nil).size
    }
}
