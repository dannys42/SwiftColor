//
//  BaseTypes.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//
import Foundation

//#if canImport(UIKit)
//import UIKit
//public typealias ColorUnit = CGFloat
//#else
public typealias ColorUnit = Double
//#endif

internal extension ColorUnit {
    var cubeRoot: ColorUnit {
        self < 0 ? -pow(-self, 1/3) : pow(self, 1/3)
    }

    func clamped(to range: ClosedRange<ColorUnit>) -> ColorUnit {
        max(range.lowerBound, min(self, range.upperBound))
    }
}
