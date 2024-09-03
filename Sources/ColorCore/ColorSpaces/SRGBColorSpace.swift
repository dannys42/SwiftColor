//
//  SRGBColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//

import Foundation

struct SRGBColorSpace: RelativeColorSpace {
    var red, green, blue: ColorUnit
    var components: (ColorUnit, ColorUnit, ColorUnit) { (red, green, blue) }

    static let standardWhitePoint = CIExyY.D65WhitePoint

    func toXYZ(relativeTo whitePoint: CIExyY) -> XYZColorSpace {
        return toLinearSRGB().toXYZ(relativeTo: whitePoint)
    }

    static func fromXYZ(_ xyz: XYZColorSpace, relativeTo whitePoint: CIExyY) -> SRGBColorSpace {
        return fromLinearSRGB(LinearSRGBColorSpace.fromXYZ(xyz, relativeTo: whitePoint))
    }

    func toLinearSRGB() -> LinearSRGBColorSpace {
        func transform(_ v: ColorUnit) -> ColorUnit {
            return v <= 0.04045 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4)
        }
        return LinearSRGBColorSpace(red: transform(red), green: transform(green), blue: transform(blue))
    }

    static func fromLinearSRGB(_ linear: LinearSRGBColorSpace) -> SRGBColorSpace {
        func transform(_ v: ColorUnit) -> ColorUnit {
            return v <= 0.0031308 ? 12.92 * v : 1.055 * pow(v, 1/2.4) - 0.055
        }
        return SRGBColorSpace(red: transform(linear.red), green: transform(linear.green), blue: transform(linear.blue))
    }
}
