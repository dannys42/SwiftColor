//
//  BaseTypes.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//
import Foundation

public typealias ColorUnit = Double

internal extension ColorUnit {
    var cubeRoot: ColorUnit {
        self < 0 ? -pow(-self, 1/3) : pow(self, 1/3)
    }

    func clamped(to range: ClosedRange<ColorUnit>) -> ColorUnit {
        max(range.lowerBound, min(self, range.upperBound))
    }
}

