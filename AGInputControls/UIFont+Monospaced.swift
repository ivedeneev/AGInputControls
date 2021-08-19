//
//  UIFont+Monospaced.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 8/18/21.
//

import UIKit

public extension UIFont {
    
    /// Provides monospaced version of given font
    var monospaced: UIFont {
            let bodyMonospacedNumbersFontDescriptor = fontDescriptor
                .addingAttributes([
              UIFontDescriptor.AttributeName.featureSettings: [
                [UIFontDescriptor.FeatureKey.featureIdentifier:
                 kNumberSpacingType,
                 UIFontDescriptor.FeatureKey.typeIdentifier:
                    kMonospacedNumbersSelector]
              ]
            ])
            
            return UIFont(descriptor: bodyMonospacedNumbersFontDescriptor, size: pointSize)
    }
}
