//
//  Color+AbsoluteColorSpaces.swift
//  Color
//
//  Created by Danny Sung on 9/3/24.
//

import SwiftUI
import ColorSpaces
import ColorSpaces_AppKit_UIKit

// MARK: LinearRGB
@available(iOS 14.0, *)
extension Color {
    public func toLinearRGB() -> LinearRGBColorSpace {
        PlatformColorType(self).toLinearRGB()
    }


    public init(linearRGB: LinearRGBColorSpace, alpha: ColorUnit = 1.0) {
        let uiColor = PlatformColorType(linearRGB: linearRGB, alpha: 1.0)

        self.init(platformColor: uiColor)
    }

    public func withLinearRGB(red: ColorUnit?=nil, green: ColorUnit?=nil, blue: ColorUnit?=nil, alpha: ColorUnit?=nil) -> Color {
        let uiColor = PlatformColorType(self).withLinearRGB(red: red, green: green, blue: blue, alpha: alpha)

        return Color(platformColor: uiColor)
    }
}

// MARK: XYZ
extension Color {
    public func toXYZ() -> XYZColorSpace {
        self.toLinearRGB().toXYZ()
    }

    public init(xyz: XYZColorSpace, alpha: ColorUnit = 1.0) {
        let linearRGB = xyz.toLinearRGBColorSpace()
        self.init(linearRGB: linearRGB, alpha: alpha)
    }

    public func withXYZ(x: ColorUnit?=nil, y: ColorUnit?=nil, z: ColorUnit?=nil, alpha: ColorUnit?=nil) -> Color {
        let uiColor = PlatformColorType(self)
        let xyz = uiColor.toXYZ().withXYZ(x: x, y: y, z: z)

        return Color(xyz: xyz, alpha: alpha ?? uiColor.cgColor.alpha)
    }
}


// MARK: HSLuv
extension Color {
    public func toHSLuv() -> HSLuvColorSpace {
        PlatformColorType(self).toHSLuv()
    }

    public init(hsluv: HSLuvColorSpace, alpha: ColorUnit = 1.0) {
        let linearRGB = hsluv.toLinearRGBColorSpace()
        self.init(linearRGB: linearRGB, alpha: CGFloat(alpha))
    }

    public func withHSLuv(hue: ColorUnit?=nil, saturation: ColorUnit?=nil, lightness: ColorUnit?=nil, alpha: ColorUnit?=nil) -> Color {

        let uiColor = PlatformColorType(self)

        var hsluv = uiColor.toHSLuv()
        hsluv = hsluv.withHSLuv(hue: hue, saturation: saturation, lightness: lightness)
        let linearRGB = hsluv.toLinearRGBColorSpace()

        return Color(linearRGB: linearRGB, alpha: alpha ?? uiColor.cgColor.alpha)
    }
}
