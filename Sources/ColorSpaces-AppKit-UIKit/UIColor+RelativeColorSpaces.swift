//
//  File.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

import ColorSpaces


#if canImport(UIKit) || canImport(AppKit)

// MARK: HSB
extension PlatformColorType {
    public func toHSB(relativeTo whitepoint: CIExyY = HSBColorSpace.standardWhitePoint) -> HSBColorSpace {
        let xyz = self.toXYZ()
        return HSBColorSpace(xyz, relativeTo: whitepoint)
    }

    public convenience init(hsb: HSBColorSpace, alpha: ColorUnit = 1.0, relativeTo whitepoint: CIExyY = HSBColorSpace.standardWhitePoint) {
        let xyz = hsb.toXYZ(relativeTo: whitepoint)
        self.init(xyz: xyz, alpha: alpha)
    }

    public func withHSB(hue: ColorUnit?=nil, saturation: ColorUnit?=nil, brightness: ColorUnit?=nil, alpha: ColorUnit?=nil, relativeTo whitePoint: CIExyY = HSBColorSpace.standardWhitePoint) -> PlatformColorType {

        var hsb = self.toHSB(relativeTo: whitePoint)
        
        hsb = hsb.withHSB(hue: hue, saturation: saturation, brightness: brightness, relativeTo: whitePoint)

        return PlatformColorType(hsb: hsb, alpha: alpha ?? self.cgColor.alpha)
    }
}

#endif
