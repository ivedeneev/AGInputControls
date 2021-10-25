//
//  FormattingTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 8/16/21.
//

import UIKit

open class FormattingTextField: UITextField {
    open var formattingMask: String? {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    ///  Mask to be draw as example. Default is nit and no example mask is drawn. Placeholder is ignored if exaplmeMask is non null
    open var exampleMask: String? {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    /// Color of placeholder. Default is `UIColor.lightGray`
    open var placeholderColor: UIColor = .lightGray
    
    internal var showsMask: Bool { exampleMask != nil }
    
    internal var prefix: String {
        guard let separator = formattingMask?.first(where: { !($0.isNumber || $0.isLetter) }) else { return "" }
        
        return formattingMask?.components(separatedBy: String(separator)).first ?? ""
    }
    
    internal var hasConstantPrefix: Bool {
        !self.prefix.contains("X") && !self.prefix.isEmpty
    }
    
    open override var intrinsicContentSize: CGSize {
        guard let exampleMask = exampleMask else {
            return super.intrinsicContentSize
        }
        
        let font_ = font ?? UIFont.systemFont(ofSize: 17)
        let height = font_.lineHeight
        let width = sizeOfText(exampleMask).width
        
        let caretWidth: CGFloat = caretRect(for: endOfDocument).width
        
        return CGSize(width: width + caretWidth, height: height)
    }
    
    open override var font: UIFont? {
        didSet {
            minimumFontSize = font?.pointSize ?? 17
            invalidateIntrinsicContentSize()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        registerTextListener()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        registerTextListener()
    }
    
    private func registerTextListener() {
        borderStyle = .none // This is important. bordered style adds its own la
        addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
    }
    
    @objc internal func didChangeEditing() {
        var pos = currentPosition()
        let textCount = text?.count ?? 0
        
        let formatted = formattedText(text: text)
        self.text = formatted
        
        guard let last = text?.prefix(pos).last else { return }
        
        if !last.isNumber {
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
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard !showsMask else { return .zero }
        return super.placeholderRect(forBounds: bounds)
    }
    
    open override func caretRect(for position: UITextPosition) -> CGRect {
        guard showsMask, hasConstantPrefix else {
            return super.caretRect(for: position)
        }
        
        var rect = super.caretRect(for: position)
        if text?.isEmpty ?? true {
            rect.origin.x += sizeOfText(prefix).width
            return rect
        }
        return rect
    }
    
    open func setFormattedText(_ text: String) {
        self.text = formattedText(text: text)
    }
    
    open override func deleteBackward() {
        guard
            let range = selectedTextRange,
            var txt = self.text,
            !txt.isEmpty,
            let formattingMask = self.formattingMask
        else {
            super.deleteBackward()
            return
        }
        
        let cursorPosition = offset(from: beginningOfDocument, to: range.start)
        
        if !range.isEmpty/* && !(formattingMask.contains("L") || formattingMask.contains("A"))*/ {
            setFormattedText(String(txt.prefix(cursorPosition)))
            return
        }
        
        if !isValidCharachter(txt.prefix(cursorPosition).last) {
            var charsToRemove = 0
            while !isValidCharachter(txt.prefix(cursorPosition - charsToRemove).last), !txt.isEmpty {
                charsToRemove += 1
                txt.remove(at: .init(utf16Offset: cursorPosition - charsToRemove, in: txt))
            }
            
            charsToRemove += 1
            txt.remove(at: .init(utf16Offset: cursorPosition - charsToRemove, in: txt))

            setFormattedText(txt)
            setCursorPosition(offset: cursorPosition - charsToRemove)
            return
        }
        
        if !isValidCharachter(txt.dropLast().last) {
            let numberToDrop = min(txt.count, 2)  // what if last 2-3 symbols are invalid? is it possible?
            txt.removeLast(numberToDrop)
            setFormattedText(txt)
            setCursorPosition(offset: cursorPosition - numberToDrop)
            return
        }
        
        super.deleteBackward()
        setCursorPosition(offset: cursorPosition - 1)
    }
    
    open func isValidCharachter(_ ch: Character?) -> Bool {
        guard let char = ch else { return false }
        return char.isNumber
    }
    
    open func drawExampleMask(rect: CGRect) {
        guard let mask = exampleMask else { return }
        assert(mask == formattedText(text: mask), "Formatting mask and example mask should be in same format. This is your responsibility as a developer")
        let text = self.text ?? ""

        let _text = text + mask.suffix(mask.count - text.count)
        let textToDraw = NSMutableAttributedString(string: _text, attributes: [
            .font : font,
            .foregroundColor : placeholderColor
        ])
        
            if hasConstantPrefix {
                textToDraw.addAttributes(
                    [.foregroundColor : textColor],
                    range: .init(location: 0, length: prefix.count)
                )
            }

        textToDraw.draw(at: CGPoint(x: 0, y: ((bounds.height - font!.lineHeight) / 2).rounded()))
    }
}

//MARK: Helper methods
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
