//
//  FormattingTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 8/16/21.
//

import UIKit

public protocol FormattingTextFieldDelegate: AnyObject {
    func textField(textField: FormattingTextField, didProduce text: String?, isValid: Bool)
}

open class FormattingTextField: UITextField {
    //MARK: Public properties
    /// Formatting mask.
    /// `*` - letter
    /// `#` - digit
    /// `?` - any (letter or digit)
    /// Example: `*** ## * #` stands for `ABC 12 D 3`
    open var formattingMask: String? {
        didSet {
            guard let mask = formattingMask else { return }
            formatter = DefaultFormatter(mask: mask, allowsEmptyOrNilStrings: false)
        }
    }
    
    open var formatter: Formatter? { didSet { invalidateIntrinsicContentSize() } }
    
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
    
    weak var formattingDelegate: FormattingTextFieldDelegate?
    
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
        var rect = super.caretRect(for: position)

        // let place caret ONLY AFTER prefix, if its constant
        guard showsMask, hasConstantPrefix, text?.isEmpty ?? true else {
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
            let mask = formattingMask
        else {
            super.deleteBackward()
            return
        }
        
        let cursorPosition = currentPosition()
        
        if cursorPosition <= prefix.count && hasConstantPrefix {
            setCursorPosition(offset: cursorPosition)
            return
        }
        
        if !range.isEmpty {
            if mask.contains("*") || mask.contains("?") {
                let text = String(txt.prefix(currentPosition(forStartOfRange: true)))
                setFormattedText(text)
                return
            }
        } else if hasConstantPrefix && String(txt.prefix(cursorPosition - 1)) == prefix {
            return
        }
        
        if hasConstantPrefix && range.end == endOfDocument {
            let stringByRemovingPrefix = String(txt.prefix(cursorPosition).dropFirst(prefix.count))
            if stringByRemovingPrefix.filter({ $0.isLetter || $0.isNumber }).isEmpty {
                setFormattedText(stringByRemovingPrefix)
                return
            }
        }
        
        if !isValidCharachter(txt.prefix(cursorPosition).last) && range.isEmpty {
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
        assertForExampleMasksAndPrefix()
        
        guard let mask = exampleMask,
              let font = self.font,
              let textColor = self.textColor
        else { return }
        
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
        textToDraw.draw(at: CGPoint(x: 0, y: ((bounds.height - font.lineHeight) / 2)))
    }
    
    open func formattedText(text: String?) -> String? {
        defer {
            if exampleMask != nil {
                setNeedsDisplay()
            }
        }
        guard let formatter = formatter else {
            return text
        }
        
        let result = formatter.formattedText(text: text)
        formattingDelegate?.textField(
            textField: self,
            didProduce: result,
            isValid: formatter.mask == result
        )
        return result
    }
}
