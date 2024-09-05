//
//  AbsoluteColorSpaceExtension.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//

import ColorSpaces


extension AbsoluteColorSpace {
    /// Calculates the readability score of this color as text against a background color.
    ///
    /// - Parameter background: The background color.
    /// - Returns: A readability score between 0 (unreadable) and 1 (highly readable).
    func readabilityScore(against background: Self) -> Double {
        TextReadability.readabilityScore(text: self, background: background)
    }

    /// Suggests a readable text color for this color as a background.
    ///
    /// - Parameters:
    ///   - preference: The preferred text color characteristic.
    ///   - readabilityTarget: The target readability score (0 to 1).
    ///   - colorStrategy: The strategy for suggesting colors.
    ///   - constrainHue: Whether to maintain the original hue when adjusting colors.
    /// - Returns: A suggested text color that meets the readability target.
    func suggestReadableTextColor(
        preference: TextReadability.TextPreference = .neutral,
        readabilityTarget: Double = 0.7,
        colorStrategy: TextReadability.ColorStrategy = .contrast,
        constrainHue: Bool = false
    ) -> Self {
        TextReadability.suggestReadableTextColor(
            for: self,
            preference: preference,
            readabilityTarget: readabilityTarget,
            colorStrategy: colorStrategy,
            constrainHue: constrainHue
        )
    }

    /// Adjusts this color for readability against a background color.
    ///
    /// - Parameters:
    ///   - background: The background color.
    ///   - preference: The preferred text color characteristic.
    ///   - readabilityTarget: The target readability score (0 to 1).
    ///   - constrainHue: Whether to maintain the original hue when adjusting colors.
    /// - Returns: An adjusted color that meets the readability target.
    func adjustedForReadability(
        against background: Self,
        preference: TextReadability.TextPreference = .neutral,
        readabilityTarget: Double = 0.7,
        constrainHue: Bool = false
    ) -> Self {
        TextReadability.adjustTextColor(
            text: self,
            background: background,
            preference: preference,
            readabilityTarget: readabilityTarget,
            constrainHue: constrainHue
        )
    }
}
