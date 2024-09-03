//
//  AdobeRGBColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//
import Foundation

struct AdobeRGBColorSpace: RelativeColorSpace {
    var red, green, blue: ColorUnit
    var components: (ColorUnit, ColorUnit, ColorUnit) { (red, green, blue) }

    static let standardWhitePoint = CIExyY.AdobeRGBWhitePoint

    private static let gamma: ColorUnit = 2.2
    private static let inverseGamma: ColorUnit = 1 / gamma

    func toXYZ(relativeTo whitePoint: CIExyY) -> XYZColorSpace {
        return toLinearAdobeRGB().toXYZ(relativeTo: whitePoint)
    }

    static func fromXYZ(_ xyz: XYZColorSpace, relativeTo whitePoint: CIExyY) -> AdobeRGBColorSpace {
        return fromLinearAdobeRGB(LinearAdobeRGBColorSpace.fromXYZ(xyz, relativeTo: whitePoint))
    }

    func toLinearAdobeRGB() -> LinearAdobeRGBColorSpace {
        func transform(_ v: ColorUnit) -> ColorUnit {
            return pow(v, Self.gamma)
        }
        return LinearAdobeRGBColorSpace(red: transform(red), green: transform(green), blue: transform(blue))
    }

    static func fromLinearAdobeRGB(_ linear: LinearAdobeRGBColorSpace) -> AdobeRGBColorSpace {
        func transform(_ v: ColorUnit) -> ColorUnit {
            return pow(v, Self.inverseGamma)
        }
        return AdobeRGBColorSpace(red: transform(linear.red), green: transform(linear.green), blue: transform(linear.blue))
    }

    // Convenience method to create AdobeRGB color from 8-bit integer values
    static func from8Bit(red: Int, green: Int, blue: Int) -> AdobeRGBColorSpace {
        return AdobeRGBColorSpace(
            red: ColorUnit(red) / 255,
            green: ColorUnit(green) / 255,
            blue: ColorUnit(blue) / 255
        )
    }

    // Method to get 8-bit integer values
    func to8Bit() -> (red: Int, green: Int, blue: Int) {
        func to8Bit(_ v: ColorUnit) -> Int {
            return min(max(Int(round(v * 255)), 0), 255)
        }
        return (to8Bit(red), to8Bit(green), to8Bit(blue))
    }

    // Clamping method to ensure values are in valid range
    func clamped() -> AdobeRGBColorSpace {
        func clamp(_ v: ColorUnit) -> ColorUnit {
            return min(max(v, 0), 1)
        }
        return AdobeRGBColorSpace(red: clamp(red), green: clamp(green), blue: clamp(blue))
    }
}

// utility methods to convert between AdobeRGB and sRGB
extension AdobeRGBColorSpace {
    func toSRGB() -> SRGBColorSpace {
        let xyz = self.toXYZ(relativeTo: .AdobeRGBWhitePoint)
        return SRGBColorSpace.fromXYZ(xyz, relativeTo: SRGBColorSpace.standardWhitePoint)
    }

    static func fromSRGB(_ srgb: SRGBColorSpace) -> AdobeRGBColorSpace {
        let xyz = srgb.toXYZ(relativeTo: SRGBColorSpace.standardWhitePoint)
        return AdobeRGBColorSpace.fromXYZ(xyz, relativeTo: .AdobeRGBWhitePoint)
    }
}
