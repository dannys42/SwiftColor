//
//  Color+RelativeColorSpaces.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//

import SwiftUI
import ColorSpaces
import ColorSpaces_AppKit_UIKit

// MARK: HSB
extension Color {
    public func toHSB(relativeTo whitePoint: CIExyY = HSBColorSpace.standardWhitePoint) -> HSBColorSpace {
        UIColor(self).toHSB(relativeTo: whitePoint)
    }

    public init(hsb: HSBColorSpace, alpha: ColorUnit = 1.0, relativeTo whitePoint: CIExyY = HSBColorSpace.standardWhitePoint) {
        let xyz = hsb.toXYZ(relativeTo: whitePoint)
        self.init(xyz: xyz, alpha: alpha)
    }

    public func withHSB(hue: ColorUnit?=nil, saturation: ColorUnit?=nil, brightness: ColorUnit?=nil, alpha: ColorUnit?=nil, relativeTo whitePoint: CIExyY = HSBColorSpace.standardWhitePoint) -> Color {

        let uiColor = UIColor(self)

        var hsb = uiColor.toHSB(relativeTo: whitePoint)
        hsb = hsb.withHSB(hue: hue, saturation: saturation, brightness: brightness)

        return Color(hsb: hsb, alpha: alpha ?? uiColor.cgColor.alpha, relativeTo: whitePoint)
    }
}

