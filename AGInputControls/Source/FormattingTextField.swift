//
//  FormattingTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 8/16/21.
//

import UIKit

open class FormattingTextField: UITextField {
    //MARK: Public properties
    /// Formatting mask.
    /// * - letter
    /// # - digit
    /// ?- any (letter or digit)
    /// Example: `*** ## * #` stands for `ABC 12 D 3`
    open var formattingMask: String? { didSet { invalidateIntrinsicContentSize() } }
    
    ///  Mask to be draw as example. Default is nil and no example mask is drawn. Placeholder is ignored if exaplmeMask is non nil
    open var exampleMask: String? { didSet { invalidateIntrinsicContentSize() } }
    
    /// Color of placeholder. Default is `UIColor.lightGray`
    open var placeholderColor: UIColor = .lightGray
    
    //MARK: Internal properties
    internal var showsMask: Bool { exampleMask != nil }
    
    internal var prefix: String {
        guard let separator = formattingMask?.first(where: { !("#?*".contains($0) || $0.isLetter || $0.isNumber) }) else { return "" }
        
        return formattingMask?.components(separatedBy: String(separator)).first ?? ""
    }
    
    internal var hasConstantPrefix: Bool {
        prefix.first(where: { "#?*".contains($0) }) == nil && !prefix.isEmpty
    }
    
    //MARK: Overriden properties
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
    
    //MARK: Init and setup methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        borderStyle = .none // This is important. bordered style adds its own layer so we cant draw example mask at this point. This behaviour may change in future
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
    
    //MARK: UITextField methods overrides
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
    
    open override func deleteBackward() {
        guard
            let range = selectedTextRange,
            var txt = self.text,
            !txt.isEmpty,
            let mask = formattingMask
        else {
            super.deleteBackward()
            return
        }
        
        let cursorPosition = offset(from: beginningOfDocument, to: range.start)
        
        if !range.isEmpty {
            if mask.contains("*") || mask.contains("?") {
                setFormattedText(String(txt.prefix(cursorPosition)))
                return
            }
        }
        
        if hasConstantPrefix {
            let stringByRemovingPrefix = String(txt.prefix(cursorPosition).dropFirst(prefix.count))
            if stringByRemovingPrefix.filter({ $0.isLetter || $0.isNumber }).isEmpty {
                setFormattedText(stringByRemovingPrefix)
                return
            }
        }
        
        if !isValidCharachter(txt.prefix(cursorPosition).last) {
            var charsToRemove = 0
            while !isValidCharachter(txt.prefix(cursorPosition - charsToRemove).last), !txt.isEmpty {
                charsToRemove += 1
                txt.remove(at: .init(utf16Offset: max(0, cursorPosition - charsToRemove), in: txt))
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
        if range.isEmpty {
            setCursorPosition(offset: cursorPosition - 1)
        } else {
            setCursorPosition(offset: cursorPosition)
        }
    }
    
    //MARK: Public methods
    open func setFormattedText(_ text: String) {
        self.text = formattedText(text: text)
    }

    open func isValidCharachter(_ ch: Character?) -> Bool {
        guard let char = ch else { return false }
        return char.isNumber || char.isLetter
    }
    
    open func drawExampleMask(rect: CGRect) {
        guard let mask = exampleMask else { return }
        
        assert(mask == formattedText(text: mask), "Formatting mask and example mask should be in same format. This is your responsibility as a developer")
        assert(prefix.first(where: { $0.isLetter || $0.isNumber }) == nil || hasConstantPrefix, "You cannot have 'semi constant' prefixes at this point ")
        
        guard let font = self.font, let textColor = self.textColor else { return }
        
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

        textToDraw.draw(at: CGPoint(x: 0, y: ((bounds.height - font.lineHeight) / 2).rounded()))
    }
    
    open func formattedText(text: String?) -> String? {
        guard let mask = formattingMask, let t = text else { return text }

        var textRemovingSpecialSymbols = String(t.filter { isValidCharachter($0) })

        // insert prefix if its constant
        if hasConstantPrefix,
           !textRemovingSpecialSymbols.hasPrefix(prefix) {
            textRemovingSpecialSymbols.insert(
                contentsOf: prefix,
                at: textRemovingSpecialSymbols.startIndex
            )
        }
        
        var result = ""
        var index = hasConstantPrefix ?
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
        
        if exampleMask != nil {
            setNeedsDisplay()
        }
        
        if textRemovingSpecialSymbols == prefix && hasConstantPrefix {
            return textRemovingSpecialSymbols.uppercased()
        }
        
        // consider string which contains only special symbols and spases invalid
        if result.filter({ $0.isLetter || $0.isNumber }).isEmpty {
            return nil
        }
        
        return result.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
