# AGInputControls

This library contains 3 UITextField subclasses: 
* `OTPCodeTextField` - textfield for sms codes
* `PhoneTextField` - textfield for phone input (currentrly only one phone mask is supported)
* `FloatingLabelTextField` - analog for Android textfield with floating placeholder

![How it looks](https://github.com/ivedeneev/AGInputControls/blob/main/Screenshots/visual.png "How it looks")


Library also provides basic class `FormattingTextField` which can format input text respecting given mask. **Important note:** FormattingTextField supports only digits. You may use special characters like spaces or dashes in mask. Example of mask: `"+X (XXX) XXX-XX-XX"`. Example of mask which can cause undefined behaviour: `"+7 (9XX) XXX-XX-XX"`

**Bonus:** UIFont extension which provides monospaced version of each font. Could be usefull for sms code input.
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
    let codeField = OTPCodeField()
    codeField.decoration = .rect
    codeField.letterSpacing = 20
    codeField.length = 6
```

### You can customize:
* Code length
* Letter spacing
* Digit decoration and its color
* All default `UITextField` properties

### Current limitations:
* Placeholders are not supported
* Caret is invisible (my personal UI preference)
* You cannot use copy/cut/paste actions 

## PhoneTextField
You can use this textfield for mobile phone number input

### Usage
```swift
    let codeField = PhoneTextField()
    codeField.phoneMask = "+X (XXX) XXX-XX-XX"
```

* Support auto-sizing respecting given font.

### Current limitations:
* Only one phone mask supported at this moment (You can override this behaviour. See below)
* Phone mask 

## FloatingLabelTextField
You can use this textfield for mobile phone number input

### Usage
```swift
    let floatTextField = FloatingLabelTextField()
    floatTextField.formattingMask = "XX/XX"
    floatTextField.placeholder = "Card number"
    floatTextField.padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    floatTextField.highlightsWhenActive = true
```

* Support auto-sizing height respecting given font
* Support input masks

## FormattingTextField
You can use this textfield for formatting input text with digits like phione numbers, credit card data input (number, expires, cvv) etc. You should specify correct `formattingMask` property to make it work. Rules of 'correct' formatting mask:
- No digits or letters
- X is a placeholder for digit

### Usage
```swift
    let floatTextField = FormattingTextField()
    floatTextField.formattingMask = "XX/XX"
```

If you need your own formatting behaviour you can subclass `FormattingTextField` and create your own textfield. In that case you should override formatting function.

```swift
class MyTextField: FormattingTextField {
    override func formattedText(text: String?) -> String? {
        return text?.uppercased()
    }
}
```
This also applies to `PhoneTextField` and `FloatingLabelTextField`