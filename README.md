# AGInputControls

This library contains 3 UITextField subclasses: 
* `OTPCodeTextField` - textfield for sms codes
* `PhoneTextField` - textfield for phone input (currentrly only one phone mask is supported)
* `FloatingLabelTextField` - analog for Android textfield with floating placeholder (animated)
* **Bonus:** UIFont extension which provides monospaced version of given font. Could be usefull for sms code input.

![How it looks](https://github.com/ivedeneev/AGInputControls/blob/main/Previews/visual.png "How it looks")

![How it looks](https://github.com/ivedeneev/AGInputControls/blob/main/Previews/float_anim.gif "How it looks")

## Installation

### CocoaPods
`pod 'AGInputControls'`

### Carthage
`github "ivedeneev/AGInputControls"`

### Swift Package Manager
Add this line to your `Package.swift` file: `.package(url: "https://github.com/ivedeneev/AGInputControls", branch: "master")`


Library also provides basic class `FormattingTextField` which can format input text respecting given mask. 
**Important note:** FormattingTextField  supports only digits. You may use special characters like spaces or dashes in mask. Example of mask: `"+X (XXX) XXX-XX-XX"`. Example of mask which can cause undefined behaviour: `"+7 (9XX) XXX-XX-XX"` `PhoneTextField` and `FloatingLabelTextField` are inherited from `FormattingTextField`

## UIFont monospaced

```swift
import AGInputControls

let codeFont = UIFont(name: "Avenir", size: 30)?.monospaced
```

## OTPCodeTextField
You can use this textfield for sms codes.

* Support auto-sizing respecting given font. **Using monospaced font is highly recommended**
* Support system auto-fill
* Support digit decoration (underline dash or rounded rect behind each digit)

### Usage
```swift
    let codeField = OTPCodeTextField()
    codeField.decoration = .rect // Decoration: rounded rects, dashes or none. See OTPCodeField.Decoration
    codeField.decorationColor = UIColor.systemGreen // Color of decoration elements
    codeField.letterSpacing = 20 // Spacing between digits
    codeField.length = 6 // Number of digits in code
    codeField.showCaret = false // Show or hide caret
```

### Current limitations:
* Placeholders are not supported
* You cannot use copy/cut/paste actions

## PhoneTextField
You can use this textfield for mobile phone number input

### Usage
```swift
    let codeField = PhoneTextField()
    codeField.phoneMask = "+# (###) ###-##-##"
```

* Supports auto-sizing respecting given font and mask.
* Supports constant prefixes. Example: if you support only phones which begins with +7 you can specify phone mask like this: +7 ### ###-##-## and +7 prefix will become 'constant' and user will not be able to erase or edit it

### Current limitations:
* Only one phone mask supported at this moment.


You can override this behaviour by subclassing `PhoneTextField` and override `formattedText(text:)` method or use `formattingDelegate` property and customize formatting behavoiur without creating subclasses

## FloatingLabelTextField
FloatingLabelTextField is a `UITextField` subclass which resembles [Material design text field](https://m2.material.io/components/text-fields)

### Usage
```swift
    let floatTextField = FloatingLabelTextField()
    floatTextField.formattingMask = "##/##" // Formatting mask
    floatTextField.placeholder = "Expires at"
    floatTextField.textPaddings = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0) // Paddings for text and floating placeholder
    floatTextField.highlightsWhenActive = true // Placeholder and underline view and bottom label are filled by tintColor when textfield is active

    floatTextField.errorTintColor = .systemRed
    floatTextField.isError = true // if true, placeholder and underline view and bottom label are filled by errorTintColor
```

* Supports auto-sizing height respecting given font and paddings
* Supports input masks
* `placeholderColor` is used for coloring underline view and bottom label for default state
* If you dont need any formatting behaviour just dont specify `formattingMask` (its `nil` by default)

## FormattingTextField
You can use this textfield for formatting input text with digits like phione numbers, credit card data input (number, expires, cvv) etc. You should specify `formattingMask` property to make it work. Formatting mask has 2 constraints:
- No digits or letters
- `#` is a placeholder for digit
- `*` is a placeholder for letter
- `?` is a placeholder for either letter or digit

### Usage
```swift
    let floatTextField = FormattingTextField()
    floatTextField.formattingMask = "##/##"
```

If you need your own formatting behaviour you can subclass `FormattingTextField` and create your own textfield. In that case you should override formatting function.

```swift
class MyTextField: FormattingTextField {
    override func formattedText(text: String?) -> String? {
        return text?.uppercased()
    }
}
```
Remember: `PhoneTextField` and `FloatingLabelTextField` are inherited from `FormattingTextField`
