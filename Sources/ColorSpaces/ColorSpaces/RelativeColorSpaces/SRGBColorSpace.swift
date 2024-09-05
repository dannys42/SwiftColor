//
//  SRGBColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//

import Foundation

public struct SRGBColorSpace: RelativeColorSpace {
    // red, green, blue: 0-1
    public var red, green, blue: ColorUnit

    // Components are in the range 0-1
    public var components: (ColorUnit, ColorUnit, ColorUnit) { (red, green, blue) }

    public static let standardWhitePoint = CIExyY.ColorSpace.AppleP3

    init(red: ColorUnit, green: ColorUnit, blue: ColorUnit) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    public func toXYZ(relativeTo whitePoint: CIExyY) -> XYZColorSpace {
        return toLinearSRGB().toXYZ(relativeTo: whitePoint)
    }

    public init(_ xyz: XYZColorSpace, relativeTo whitePoint: CIExyY) {
        self.init(LinearSRGBColorSpace(xyz, relativeTo: whitePoint))
    }

    public func toLinearSRGB() -> LinearSRGBColorSpace {
        func transform(_ v: ColorUnit) -> ColorUnit {
            return v <= 0.04045 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4)
        }
        return LinearSRGBColorSpace(red: transform(red), green: transform(green), blue: transform(blue))
    }

    public init(_ linear: LinearSRGBColorSpace) {
        func transform(_ v: ColorUnit) -> ColorUnit {
            return v <= 0.0031308 ? 12.92 * v : 1.055 * pow(v, 1/2.4) - 0.055
        }
        self.init(red: transform(linear.red), green: transform(linear.green), blue: transform(linear.blue))
    }
}

extension RelativeColorSpace {
    public func toSRGBColorSpace(relativeTo whitePoint: CIExyY = Self.standardWhitePoint) -> SRGBColorSpace {
        if let srgb = self as? SRGBColorSpace {
            return srgb
        }
        return SRGBColorSpace(self.toXYZ(relativeTo: whitePoint), relativeTo: whitePoint)
    }

    public init(srgb: SRGBColorSpace, relativeTo whitePoint: CIExyY = Self.standardWhitePoint) {
        self.init(srgb.toXYZ(relativeTo: whitePoint), relativeTo: whitePoint)
    }
}
