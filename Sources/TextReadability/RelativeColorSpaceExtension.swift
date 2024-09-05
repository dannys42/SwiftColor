//
//  RelativeColorSpaceExtension.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//

import ColorSpaces

extension RelativeColorSpace {
    func readabilityScore(against background: Self, relativeTo whitePoint: CIExyY = Self.standardWhitePoint) -> Double {
        let textXYZ = self.toXYZ(relativeTo: whitePoint)
        let backgroundXYZ = background.toXYZ(relativeTo: whitePoint)
        return TextReadability.readabilityScore(text: textXYZ, background: backgroundXYZ)
    }

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
