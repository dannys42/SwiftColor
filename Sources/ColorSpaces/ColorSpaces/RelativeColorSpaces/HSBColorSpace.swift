//
//  HSBColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//


// HSBColorSpace.swift

import Foundation

public struct HSBColorSpace: RelativeColorSpace {
    // hue: 0-1 (maps to 0-360 degrees)
    // saturation: 0-1 (maps to 0-100%)
    // brightness: 0-1 (maps to 0-100%)
    public var hue, saturation, brightness: ColorUnit
    
    // Components are in the range 0-1
    public var components: (ColorUnit, ColorUnit, ColorUnit) { (hue, saturation, brightness) }

    public static let standardWhitePoint = CIExyY.ColorSpace.AppleP3

    public init(hue: ColorUnit, saturation: ColorUnit, brightness: ColorUnit) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
    }

    public func toXYZ(relativeTo whitePoint: CIExyY) -> XYZColorSpace {
        return toSRGB().toXYZ(relativeTo: whitePoint)
    }

    public init(_ xyz: XYZColorSpace, relativeTo whitePoint: CIExyY) {
        self.init(SRGBColorSpace(xyz, relativeTo: whitePoint))
    }

    public func toSRGB() -> SRGBColorSpace {
        let c = brightness * saturation
        let x = c * (1 - abs((hue * 6).truncatingRemainder(dividingBy: 2) - 1))
        let m = brightness - c

        let (r, g, b): (ColorUnit, ColorUnit, ColorUnit)
        switch hue * 6 {
        case 0..<1: (r, g, b) = (c, x, 0)
        case 1..<2: (r, g, b) = (x, c, 0)
        case 2..<3: (r, g, b) = (0, c, x)
        case 3..<4: (r, g, b) = (0, x, c)
        case 4..<5: (r, g, b) = (x, 0, c)
        default:    (r, g, b) = (c, 0, x)
        }

        return SRGBColorSpace(red: r + m, green: g + m, blue: b + m)
    }

    public init(_ srgb: SRGBColorSpace) {
        let max = Swift.max(srgb.red, srgb.green, srgb.blue)
        let min = Swift.min(srgb.red, srgb.green, srgb.blue)
        let chroma = max - min

        let brightness = max

        let saturation = max == 0 ? 0 : chroma / max

        let hue: ColorUnit
        if chroma == 0 {
            hue = 0
        } else if max == srgb.red {
            hue = ((srgb.green - srgb.blue) / chroma).truncatingRemainder(dividingBy: 6) / 6
        } else if max == srgb.green {
            hue = ((srgb.blue - srgb.red) / chroma + 2) / 6
        } else {
            hue = ((srgb.red - srgb.green) / chroma + 4) / 6
        }

        self.init(hue: hue, saturation: saturation, brightness: brightness)
    }
}

extension RelativeColorSpace {
    public func toHSBColorSpace(relativeTo whitePoint: CIExyY = Self.standardWhitePoint) -> HSBColorSpace {
        if let hsb = self as? HSBColorSpace {
            return hsb
        }
        return HSBColorSpace(self.toXYZ(relativeTo: whitePoint), relativeTo: whitePoint)
    }

    public init(hsb: HSBColorSpace, relativeTo whitePoint: CIExyY = Self.standardWhitePoint) {
        self.init(hsb.toXYZ(relativeTo: whitePoint), relativeTo: whitePoint)
    }

    public func withHSB(hue: ColorUnit?=nil, saturation: ColorUnit?=nil, brightness: ColorUnit?=nil, relativeTo whitePoint: CIExyY = Self.standardWhitePoint) -> HSBColorSpace {
        var hsb = self.toHSBColorSpace(relativeTo: whitePoint)

        if let hue {
            hsb.hue = hue
        }
        if let saturation {
            hsb.saturation = saturation
        }
        if let brightness {
            hsb.brightness = brightness
        }

        return hsb
    }

}
