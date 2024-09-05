//
//  UIColor+Extension.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

import ColorSpaces


#if canImport(UIKit) || canImport(AppKit)

// MARK: LinearRGB
extension PlatformColorType {
    public func toLinearRGB() -> LinearRGBColorSpace {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return LinearRGBColorSpace(red: red, green: green, blue: blue)
    }


    public convenience init(linearRGB: LinearRGBColorSpace, alpha: ColorUnit = 1.0) {
        self.init(red: linearRGB.red, green: linearRGB.green, blue: linearRGB.blue, alpha: alpha)
    }

    public func withLinearRGB(red: ColorUnit?=nil, green: ColorUnit?=nil, blue: ColorUnit?=nil, alpha: ColorUnit?=nil) -> PlatformColorType {
        var linearRGB = self.toLinearRGB()
        linearRGB = linearRGB.withLinearRGB(red: red, green: green, blue: blue)

        return PlatformColorType(red: linearRGB.red, green: linearRGB.green, blue: linearRGB.blue, alpha: alpha ?? self.cgColor.alpha)
    }
}

// MARK: XYZ
extension PlatformColorType {
    public func toXYZ() -> XYZColorSpace {
        self.toLinearRGB().toXYZ()
    }

    public convenience init(xyz: XYZColorSpace, alpha: ColorUnit = 1.0) {
        let linearRGB = xyz.toLinearRGBColorSpace()
        self.init(linearRGB: linearRGB, alpha: alpha)
    }

    public func withXYZ(x: ColorUnit?=nil, y: ColorUnit?=nil, z: ColorUnit?=nil, alpha: ColorUnit?=nil) -> PlatformColorType {
        let xyz = self.toXYZ().withXYZ(x: x, y: y, z: z)

        return PlatformColorType(xyz: xyz, alpha: alpha ?? self.cgColor.alpha)
    }
}

// MARK: HSLuv
extension PlatformColorType {
    public func toHSLuv() -> HSLuvColorSpace {
        let linearRGB = self.toLinearRGB()
        let hsluv = linearRGB.toHSLuvColorSpace()
        return hsluv
    }

    public convenience init(hsluv: HSLuvColorSpace, alpha: ColorUnit = 1.0) {
        let linearRGB = hsluv.toLinearRGBColorSpace()
        self.init(linearRGB: linearRGB, alpha: CGFloat(alpha))
    }

    public func withHSLuv(hue: ColorUnit?=nil, saturation: ColorUnit?=nil, lightness: ColorUnit?=nil, alpha: ColorUnit?=nil) -> PlatformColorType {

        var hsluv = self.toHSLuv()
        hsluv = hsluv.withHSLuv(hue: hue, saturation: saturation, lightness: lightness)

        return PlatformColorType(hsluv: hsluv, alpha: alpha ?? self.cgColor.alpha)
    }
}

#endif
