//
//  FormattingTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 8/16/21.
//

import UIKit

public protocol FormattingTextFieldDelegate: AnyObject {
    func textField(textField: FormattingTextField, didProduce text: String?, isValid: Bool)
    func textField(textField: FormattingTextField, didOccurUnacceptedCharacter char: Character)
}

open class FormattingTextField: UITextField {
    //MARK: Public properties
    /// Formatting mask.
    /// `*` - letter
    /// `#` - digit
    /// `?` - any (letter or digit)
    /// Example: `*** ## * #` stands for `ABC 12 D 3`
    open var formattingMask: String? {
        get {
            formatter?.mask
        }
        
        set {
            guard let mask = newValue else { return }
            formatter = DefaultFormatter(mask: mask, allowsEmptyOrNilStrings: false)
        }
    }
    
    open override var text: String? {
        get {
            super.text
        }
        
        set {
            let formatted = formattedText(text: newValue)
            let pos = currentPosition()
            super.text = formatted
            notifyDelegate(text: text)
            setCaretPositionAfterSettingText(
                currentPosition: pos,
                rawText: newValue,
                formattedText: formatted
            )
        }
    }
    
    /// Formatter object in case you need your own formatting logic
    open var formatter: AGFormatter? { didSet { invalidateIntrinsicContentSize() } }
    
    ///  Mask to be draw as example. Default is nil and no example mask is drawn. Placeholder is ignored if exaplmeMask is non nil
    open var exampleMask: String? { didSet { invalidateIntrinsicContentSize() } }
    
    /// Color of placeholder. Default is `UIColor.lightGray`
    open var placeholderColor: UIColor = .lightGray
    
    //MARK: Internal properties
    internal var showsMask: Bool { exampleMask != nil }
    private lazy var _showsMask = showsMaskIfEmpty
    
    open var showsMaskIfEmpty: Bool = true
    
    internal var prefix: String {
        formatter?.prefix ?? ""
    }
    
    internal var hasConstantPrefix: Bool {
        formatter?.maskHasConstantPrefix ?? false
    }
    
    open weak var formattingDelegate: FormattingTextFieldDelegate?
    
    //MARK: Overriden properties
    open override var intrinsicContentSize: CGSize {
        guard let exampleMask = formattingMask?
            .replacingOccurrences(of: "#", with: "0")
            .replacingUnderscoresWithZeros(),
            !exampleMask.isEmpty // in case of monospaced digit fonts calculatiing width againts only digit text produces more accurate results
        else {
            return super.intrinsicContentSize
        }
        
        let font_ = font ?? UIFont.preferredFont(forTextStyle: .body)
        let height = font_.lineHeight
        let width = sizeOfText(exampleMask).width
        
        let caretWidth: CGFloat = caretRect(for: endOfDocument).width
        let padding: CGFloat = 0
        
        return CGSize(width: width + caretWidth + padding * 2, height: height)
    }
    
    open override var font: UIFont? {
        didSet {
            minimumFontSize = font?.pointSize ?? UIFont.systemFontSize
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
        self.text = text
    }
    
    //MARK: UITextField methods overrides
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawExampleMask(rect: rect)
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard !showsMask && formatter != nil else { return .zero }
        return super.placeholderRect(forBounds: bounds)
    }
    
    open override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)

        // let place caret ONLY AFTER prefix, if its constant
        guard showsMask, hasConstantPrefix, text.isEmptyOrTrue else {
            return rect
        }

        rect.origin.x = sizeOfText(prefix).width
        return rect
    }
    
    open override func deleteBackward() {
        guard
            let range = selectedTextRange,
            var txt = self.text,
            !txt.isEmpty,
            let mask = formattingMask,
            !mask.isEmpty
        else {
            super.deleteBackward()
            return
        }
        
        let cursorPosition = currentPosition()
        
        guard cursorPosition != 0 else { return } // nothing to delete if we place cursor at the beginning of the text
        
        if cursorPosition <= prefix.count && hasConstantPrefix {
            setCursorPosition(offset: cursorPosition)
            return
        }
        
        if !range.isEmpty {
            if mask.contains("*") || mask.contains("?") {
                let text = String(txt.prefix(currentPosition(forStartOfRange: true)))
                self.text = text
                return
            }
        } else if hasConstantPrefix && String(txt.prefix(cursorPosition - 1)) == prefix {
            return
        }
        
        if hasConstantPrefix && range.end == endOfDocument {
            let stringByRemovingPrefix = String(txt.prefix(cursorPosition).dropFirst(prefix.count))
            if stringByRemovingPrefix.filter({ $0.isLetter || $0.isNumber }).isEmpty {
                self.text = stringByRemovingPrefix
                return
            }
        }
        
        if !isNumberOrLetter(txt.prefix(cursorPosition).last) && range.isEmpty && cursorPosition != 1 {
            var charsToRemove = 0
            while !isNumberOrLetter(txt.prefix(cursorPosition - charsToRemove).last), !txt.isEmpty {
                charsToRemove += 1
                txt.remove(at: .init(utf16Offset: max(0, cursorPosition - charsToRemove), in: txt))
            }
            
            charsToRemove += 1
            txt.remove(at: .init(utf16Offset: cursorPosition - charsToRemove, in: txt))
            text = txt
            setCursorPosition(offset: cursorPosition - charsToRemove)
            return
        }
        
        if !isNumberOrLetter(txt.dropLast().last) && range.end == endOfDocument {
            let numberToDrop = min(txt.count, 2)  // what if last 2-3 symbols are invalid? is it possible?
            txt.removeLast(numberToDrop)
            text = txt
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
    
    open override func becomeFirstResponder() -> Bool {
        if text.isEmptyOrTrue && !showsMaskIfEmpty && !_showsMask && formatter != nil {
            _showsMask = true
            setNeedsDisplay()
        }
        return super.becomeFirstResponder()
    }
    
    open override func resignFirstResponder() -> Bool {
        if text.isEmptyOrTrue && !showsMaskIfEmpty && _showsMask && formatter != nil {
            _showsMask = false
            setNeedsDisplay()
        }
        return super.resignFirstResponder()
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        guard let exampleMask = exampleMask?.replacingUnderscoresWithZeros() else {
            return super.editingRect(forBounds: bounds)
        }
        
        let w = sizeOfText(exampleMask).width
        let originX = (bounds.width - w) / 2
        return CGRect(x: originX, y: 0, width: w, height: bounds.height)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        guard let exampleMask = exampleMask?.replacingUnderscoresWithZeros() else {
            return super.editingRect(forBounds: bounds)
        }
        
        let caretWidth: CGFloat = caretRect(for: endOfDocument).width
        let w = sizeOfText(exampleMask).width
        let originX = (bounds.width - w) / 2
        return CGRect(x: originX, y: 0, width: w + caretWidth, height: bounds.height)
    }
    
    //MARK: Public methods
    @available(*, deprecated, renamed: "text", message: "Use regular text setter to set formatted text programmatically ")
    open func setFormattedText(_ text: String?) {
        self.text = formattedText(text: text)
        notifyDelegate(text: self.text)
    }

    open func isNumberOrLetter(_ ch: Character?) -> Bool {
        formatter?.isNumberOrLetter(ch) ?? true
    }
    
    open func drawExampleMask(rect: CGRect) {
        assertForExampleMasksAndPrefix()
        let text = text ?? ""
        
        guard let mask = exampleMask,
              !mask.isEmpty,
              let font,
              let textColor,
              !text.isEmpty || _showsMask
        else { return }

        let _text = text + mask.suffix(mask.count - text.count)
        let textToDraw = NSMutableAttributedString(string: _text, attributes: [
            .font : font,
            .foregroundColor : placeholderColor
        ])
        
        if !text.isEmpty {
            textToDraw.addAttributes(
                [.foregroundColor : UIColor.clear],
                range: .init(location: 0, length: text.count)
            )
        } else if hasConstantPrefix {
            textToDraw.addAttributes(
                [.foregroundColor : textColor],
                range: .init(location: 0, length: prefix.count)
            )
        }
        
        let w = sizeOfText(mask.replacingUnderscoresWithZeros()).width
        let originX = (bounds.width - w) / 2
        
        textToDraw.draw(at: CGPoint(x: originX, y: ((bounds.height - font.lineHeight) / 2)))
    }
    
    open func formattedText(text: String?) -> String? {
        defer {
            if exampleMask != nil {
                setNeedsDisplay()
            }
        }
        guard let formatter else { return text }
        
        let result = formatter.formattedText(text: text)
        return result
    }
    
    private func notifyDelegate(text: String?) {
        let isValidText = formatter?.isValidString(text: text) ?? true
        formattingDelegate?.textField(textField: self, didProduce: text, isValid: isValidText)
        
        if let formatter = formatter,
           let text = text?.filter({ $0.isLetter }),
           !formatter.acceptedLetters.isEmpty
        {
            let unacceptedLetters = Set(text).subtracting(formatter.acceptedLetters)
            if let letter = unacceptedLetters.first {
                formattingDelegate?.textField(textField: self, didOccurUnacceptedCharacter: letter)
            }
        }
    }
    
    //MARK: Private & internal
    internal func assertForExampleMasksAndPrefix() {
        guard let mask = exampleMask, !mask.isEmpty, let formattingMask = formattingMask, formatter != nil else { return }
        assert(mask == formattedText(text: mask) && mask.count == formattingMask.count, "Formatting mask and example mask should be in same format. This is your responsibility as a developer\nExampleMask: \(mask)\nFormatting mask: \(formattingMask)")
        assert(prefix.first(where: { $0.isLetter || $0.isNumber }) == nil || hasConstantPrefix, "You cannot have 'semi constant' prefixes at this point ")
    }
    
    func setCaretPositionAfterSettingText(currentPosition: Int, rawText:String?, formattedText: String?) {
        var pos = currentPosition
        let textCount = rawText?.count ?? 0
        guard let last = formattedText?.prefix(pos).last else { return }
    
        if !last.isNumber {
            pos = pos + 1 // не 1, а количество элементов до первой цифры с конца
        }
        if pos < textCount {
            setCursorPosition(offset: pos)
        } else if let count = formattedText?.count {
            let delta = count - textCount
            if abs(delta) > 2 {
                DispatchQueue.main.async { // async because it may interfere with setting cursor position initiated by system
                    self.setCursorPosition(offset: pos + delta)
                }
            }
        }
    }
}
