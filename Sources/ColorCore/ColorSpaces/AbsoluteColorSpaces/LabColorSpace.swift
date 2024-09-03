//
//  LabColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//
import Foundation

public struct LabColorSpace: AbsoluteColorSpace {
    public typealias Components = (lightness: ColorUnit, a: ColorUnit, b: ColorUnit)

    public static let name = "CIE Lab"

    public let components: Components
    public let whitePoint: CIExyY

    public init(lightness: ColorUnit, a: ColorUnit, b: ColorUnit, whitePoint: CIExyY = .D65WhitePoint) {
        self.components = (lightness: lightness, a: a, b: b)
        self.whitePoint = whitePoint
    }

    public func toXYZ() -> XYZColorSpace {
        let fy = (components.lightness + 16) / 116
        let fx = components.a / 500 + fy
        let fz = fy - components.b / 200

        let epsilon: ColorUnit = 216 / 24389
        let kappa: ColorUnit = 24389 / 27

        let xr = fx > epsilon.cubeRoot ? fx * fx * fx : (116 * fx - 16) / kappa
        let yr = components.lightness > kappa * epsilon ? fy * fy * fy : components.lightness / kappa
        let zr = fz > epsilon.cubeRoot ? fz * fz * fz : (116 * fz - 16) / kappa

        let (xw, yw, zw) = (whitePoint.x, whitePoint.y, whitePoint.Y)

        return XYZColorSpace(x: xr * xw, y: yr * yw, z: zr * zw)
    }

    public init(_ xyz: XYZColorSpace) {
        self.init(xyz, whitePoint: .D65WhitePoint)
    }

    public init(_ xyz: XYZColorSpace, whitePoint: CIExyY) {
        let (xw, yw, zw) = (whitePoint.x, whitePoint.y, whitePoint.Y)
        let xr = xyz.x / xw
        let yr = xyz.y / yw
        let zr = xyz.z / zw

        let epsilon: ColorUnit = 216 / 24389
        let kappa: ColorUnit = 24389 / 27

        let fx = xr > epsilon ? xr.cubeRoot : (kappa * xr + 16) / 116
        let fy = yr > epsilon ? yr.cubeRoot : (kappa * yr + 16) / 116
        let fz = zr > epsilon ? zr.cubeRoot : (kappa * zr + 16) / 116

        let L = 116 * fy - 16
        let a = 500 * (fx - fy)
        let b = 200 * (fy - fz)

        self.init(lightness: L, a: a, b: b, whitePoint: whitePoint)
    }

    func clamped() -> Self {
        LabColorSpace(
            lightness: components.lightness.clamped(to: 0...100),
            a: components.a.clamped(to: -128...127),
            b: components.b.clamped(to: -128...127),
            whitePoint: whitePoint
        )
    }
}

fileprivate extension ColorUnit {
    var cubeRoot: ColorUnit {
        self < 0 ? -pow(-self, 1/3) : pow(self, 1/3)
    }

    func clamped(to range: ClosedRange<ColorUnit>) -> ColorUnit {
        max(range.lowerBound, min(self, range.upperBound))
    }
}

extension AbsoluteColorSpace {
    public func toLabColorSpace() -> LabColorSpace {
        if let lab = self as? LabColorSpace {
            return lab
        }

        let xyz = self.toXYZ()

        return LabColorSpace(xyz)
    }

    init(lab: LabColorSpace) {
        self.init(lab.toXYZ())
    }
}
