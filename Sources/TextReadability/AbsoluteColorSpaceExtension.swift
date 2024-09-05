//
//  AbsoluteColorSpaceExtension.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//

import ColorSpaces


extension AbsoluteColorSpace {
    func readabilityScore(against background: Self) -> Double {
        TextReadability.readabilityScore(text: self, background: background)
    }

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
