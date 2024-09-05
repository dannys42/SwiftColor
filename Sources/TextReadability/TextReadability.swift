//
//  TextReadability.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//

import Foundation
import ColorSpaces

/// A struct providing functionality to assess and improve text readability based on color contrast.
struct TextReadability {
    /// Defines the strategy for suggesting readable text colors.
    public enum ColorStrategy {
        /// Suggests a color that contrasts with the background.
        case contrast
        /// Suggests a color similar to the background but with improved readability.
        case similar
    }

    /// Defines the preference for text color in relation to the background.
    public enum TextPreference {
        /// Prefer lighter text colors.
        case light
        /// Prefer darker text colors.
        case dark
        /// No specific preference, chooses based on background.
        case neutral
    }

    /// Calculates a readability score for text color against a background color.
    ///
    /// - Parameters:
    ///   - text: The color of the text.
    ///   - background: The color of the background.
    /// - Returns: A readability score between 0 (unreadable) and 1 (highly readable).
    static func readabilityScore<T: AbsoluteColorSpace, U: AbsoluteColorSpace>(
        text: T,
        background: U
    ) -> Double {
        let textLab = text.toLabColorSpace()
        let bgLab = background.toLabColorSpace()

        let contrastRatio = calculateContrastRatio(textLab, bgLab)
        let colorDifference = calculateCIEDE2000(textLab, bgLab)

        return combineScores(contrastRatio: contrastRatio, colorDifference: colorDifference)
    }

    /// Suggests a readable text color for a given background color.
    ///
    /// - Parameters:
    ///   - background: The background color.
    ///   - preference: The preferred text color characteristic.
    ///   - readabilityTarget: The target readability score (0 to 1).
    ///   - colorStrategy: The strategy for suggesting colors.
    ///   - constrainHue: Whether to maintain the original hue when adjusting colors.
    /// - Returns: A suggested text color that meets the readability target.
    static func suggestReadableTextColor<T: AbsoluteColorSpace>(
        for background: T,
        preference: TextPreference = .neutral,
        readabilityTarget: Double = 0.7,
        colorStrategy: ColorStrategy = .contrast,
        constrainHue: Bool = false
    ) -> T {
        let bgLab = background.toLabColorSpace()
        let suggestedLab = findReadableColor(
            background: bgLab,
            preference: preference,
            readabilityTarget: readabilityTarget,
            colorStrategy: colorStrategy,
            constrainHue: constrainHue
        )
        return T(suggestedLab.toXYZ())
    }

    /// Adjusts a text color to improve readability against a background color.
    ///
    /// - Parameters:
    ///   - text: The original text color.
    ///   - background: The background color.
    ///   - preference: The preferred text color characteristic.
    ///   - readabilityTarget: The target readability score (0 to 1).
    ///   - constrainHue: Whether to maintain the original hue when adjusting colors.
    /// - Returns: An adjusted text color that meets the readability target.
    static func adjustTextColor<T: AbsoluteColorSpace>(
        text: T,
        background: T,
        preference: TextPreference = .neutral,
        readabilityTarget: Double = 0.7,
        constrainHue: Bool = false
    ) -> T {
        let textLab = text.toLabColorSpace()
        let bgLab = background.toLabColorSpace()
        let adjustedLab = adjustColor(
            text: textLab,
            background: bgLab,
            preference: preference,
            readabilityTarget: readabilityTarget,
            constrainHue: constrainHue
        )
        return T(adjustedLab.toXYZ())
    }

    // Helper functions
    private static func calculateContrastRatio(_ color1: LabColorSpace, _ color2: LabColorSpace) -> Double {
        let l1 = color1.components.lightness / 100
        let l2 = color2.components.lightness / 100
        let lighter = max(l1, l2)
        let darker = min(l1, l2)
        return (lighter + 0.05) / (darker + 0.05)
    }

    private static func combineScores(contrastRatio: Double, colorDifference: Double) -> Double {
        // Normalize contrast ratio to 0-1 range (assuming 21:1 as max)
        let normalizedContrast = min((contrastRatio - 1) / 20, 1)

        // Normalize color difference (assuming 100 as max difference)
        let normalizedDifference = min(colorDifference / 100, 1)

        // Combine scores (you may want to adjust the weights)
        return 0.6 * normalizedContrast + 0.4 * normalizedDifference
    }

    private static func findReadableColor(
        background: LabColorSpace,
        preference: TextPreference,
        readabilityTarget: Double,
        colorStrategy: ColorStrategy,
        constrainHue: Bool
    ) -> LabColorSpace {
        var suggestedColor: LabColorSpace

        switch preference {
        case .light:
            suggestedColor = LabColorSpace(lightness: 90, a: background.components.a, b: background.components.b)
        case .dark:
            suggestedColor = LabColorSpace(lightness: 10, a: background.components.a, b: background.components.b)
        case .neutral:
            suggestedColor = background.components.lightness > 50 ?
            LabColorSpace(lightness: 10, a: background.components.a, b: background.components.b) :
            LabColorSpace(lightness: 90, a: background.components.a, b: background.components.b)
        }

        if colorStrategy == .contrast {
            suggestedColor = LabColorSpace(
                lightness: 100 - suggestedColor.components.lightness,
                a: -suggestedColor.components.a,
                b: -suggestedColor.components.b
            )
        }

        if !constrainHue {
            // Adjust a and b components to increase readability
            suggestedColor = LabColorSpace(
                lightness: suggestedColor.components.lightness,
                a: suggestedColor.components.a * 1.2,
                b: suggestedColor.components.b * 1.2
            )
        }

        return adjustColor(
            text: suggestedColor,
            background: background,
            preference: preference,
            readabilityTarget: readabilityTarget,
            constrainHue: constrainHue
        )
    }

    private static func adjustColor(
        text: LabColorSpace,
        background: LabColorSpace,
        preference: TextPreference,
        readabilityTarget: Double,
        constrainHue: Bool
    ) -> LabColorSpace {
        var adjustedColor = text
        let step: ColorUnit = 1.0
        let maxIterations = 100
        var iterations = 0

        while readabilityScore(text: adjustedColor, background: background) < readabilityTarget && iterations < maxIterations {
            switch preference {
            case .light:
                adjustedColor = LabColorSpace(
                    lightness: min(adjustedColor.components.lightness + step, 100),
                    a: constrainHue ? adjustedColor.components.a : adjustedColor.components.a * 1.01,
                    b: constrainHue ? adjustedColor.components.b : adjustedColor.components.b * 1.01
                )
            case .dark:
                adjustedColor = LabColorSpace(
                    lightness: max(adjustedColor.components.lightness - step, 0),
                    a: constrainHue ? adjustedColor.components.a : adjustedColor.components.a * 1.01,
                    b: constrainHue ? adjustedColor.components.b : adjustedColor.components.b * 1.01
                )
            case .neutral:
                if background.components.lightness > 50 {
                    adjustedColor = LabColorSpace(
                        lightness: max(adjustedColor.components.lightness - step, 0),
                        a: constrainHue ? adjustedColor.components.a : adjustedColor.components.a * 1.01,
                        b: constrainHue ? adjustedColor.components.b : adjustedColor.components.b * 1.01
                    )
                } else {
                    adjustedColor = LabColorSpace(
                        lightness: min(adjustedColor.components.lightness + step, 100),
                        a: constrainHue ? adjustedColor.components.a : adjustedColor.components.a * 1.01,
                        b: constrainHue ? adjustedColor.components.b : adjustedColor.components.b * 1.01
                    )
                }
            }
            iterations += 1
        }

        return adjustedColor
    }

    // Additional helper method for CIEDE2000 calculation
    private static func calculateCIEDE2000(_ lab1: LabColorSpace, _ lab2: LabColorSpace) -> Double {
        // This is a simplified version of CIEDE2000. For a full implementation,
        // you would need to include all the steps of the CIEDE2000 algorithm.
        let deltaL = lab2.components.lightness - lab1.components.lightness
        let deltaA = lab2.components.a - lab1.components.a
        let deltaB = lab2.components.b - lab1.components.b

        let c1 = sqrt(lab1.components.a * lab1.components.a + lab1.components.b * lab1.components.b)
        let c2 = sqrt(lab2.components.a * lab2.components.a + lab2.components.b * lab2.components.b)
        let deltaC = c2 - c1

        let deltaH = sqrt(deltaA * deltaA + deltaB * deltaB - deltaC * deltaC)

        let sL = 1.0
        let sC = 1.0 + 0.045 * c1
        let sH = 1.0 + 0.015 * c1

        let deltaLKlsl = deltaL / sL
        let deltaCkcsc = deltaC / sC
        let deltaHkhsh = deltaH / sH

        return sqrt(deltaLKlsl * deltaLKlsl + deltaCkcsc * deltaCkcsc + deltaHkhsh * deltaHkhsh)
    }
}

