//
//  RelativeColorSpaceExtension.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//

import ColorSpaces

extension RelativeColorSpace {
    /// Calculates the readability score of this color as text against a background color.
    ///
    /// - Parameters:
    ///   - background: The background color.
    ///   - whitePoint: The white point for color space conversion.
    /// - Returns: A readability score between 0 (unreadable) and 1 (highly readable).
    func readabilityScore(against background: Self, relativeTo whitePoint: CIExyY = Self.standardWhitePoint) -> Double {
        let textXYZ = self.toXYZ(relativeTo: whitePoint)
        let backgroundXYZ = background.toXYZ(relativeTo: whitePoint)
        return TextReadability.readabilityScore(text: textXYZ, background: backgroundXYZ)
    }

    /// Suggests a readable text color for this color as a background.
    ///
    /// - Parameters:
    ///   - preference: The preferred text color characteristic.
    ///   - readabilityTarget: The target readability score (0 to 1).
    ///   - colorStrategy: The strategy for suggesting colors.
    ///   - constrainHue: Whether to maintain the original hue when adjusting colors.
    ///   - whitePoint: The white point for color space conversion.
    /// - Returns: A suggested text color that meets the readability target.
    func suggestReadableTextColor(
        preference: TextReadability.TextPreference = .neutral,
        readabilityTarget: Double = 0.7,
        colorStrategy: TextReadability.ColorStrategy = .contrast,
        constrainHue: Bool = false,
        relativeTo whitePoint: CIExyY = Self.standardWhitePoint
    ) -> Self {
        let backgroundXYZ = self.toXYZ(relativeTo: whitePoint)
        let suggestedXYZ = TextReadability.suggestReadableTextColor(
            for: backgroundXYZ,
            preference: preference,
            readabilityTarget: readabilityTarget,
            colorStrategy: colorStrategy,
            constrainHue: constrainHue
        )
        return Self(suggestedXYZ, relativeTo: whitePoint)
    }

    /// Adjusts this color for readability against a background color.
    ///
    /// - Parameters:
    ///   - background: The background color.
    ///   - preference: The preferred text color characteristic.
    ///   - readabilityTarget: The target readability score (0 to 1).
    ///   - constrainHue: Whether to maintain the original hue when adjusting
    ///   - whitePoint: The white point for color space conversion.
    /// - Returns: An adjusted color that meets the readability target.
    func adjustedForReadability(
        against background: Self,
        preference: TextReadability.TextPreference = .neutral,
        readabilityTarget: Double = 0.7,
        constrainHue: Bool = false,
        relativeTo whitePoint: CIExyY = Self.standardWhitePoint
    ) -> Self {
        let textXYZ = self.toXYZ(relativeTo: whitePoint)
        let backgroundXYZ = background.toXYZ(relativeTo: whitePoint)
        let adjustedXYZ = TextReadability.adjustTextColor(
            text: textXYZ,
            background: backgroundXYZ,
            preference: preference,
            readabilityTarget: readabilityTarget,
            constrainHue: constrainHue
        )
        return Self(adjustedXYZ, relativeTo: whitePoint)
    }
}
