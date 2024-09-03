//
//  HSLColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public struct HSLColorSpace: RelativeColorSpace {
    public var hue, saturation, lightness: ColorUnit
    public var components: (ColorUnit, ColorUnit, ColorUnit) { (hue, saturation, lightness) }

    public static let standardWhitePoint = CIExyY.D65WhitePoint

    public func toXYZ(relativeTo whitePoint: CIExyY) -> XYZColorSpace {
        return toSRGB().toXYZ(relativeTo: whitePoint)
    }

    public static func fromXYZ(_ xyz: XYZColorSpace, relativeTo whitePoint: CIExyY) -> HSLColorSpace {
        return fromSRGB(SRGBColorSpace.fromXYZ(xyz, relativeTo: whitePoint))
    }

    public func toSRGB() -> SRGBColorSpace {
        let c = (1 - abs(2 * lightness - 1)) * saturation
        let x = c * (1 - abs((hue * 6).truncatingRemainder(dividingBy: 2) - 1))
        let m = lightness - c/2

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

    public static func fromSRGB(_ srgb: SRGBColorSpace) -> HSLColorSpace {
        let max = Swift.max(srgb.red, srgb.green, srgb.blue)
        let min = Swift.min(srgb.red, srgb.green, srgb.blue)
        let chroma = max - min

        let lightness = (max + min) / 2

        let saturation: ColorUnit
        if lightness == 0 || lightness == 1 {
            saturation = 0
        } else {
            saturation = (max - lightness) / Swift.min(lightness, 1 - lightness)
        }

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

        return HSLColorSpace(hue: hue, saturation: saturation, lightness: lightness)
    }
}
