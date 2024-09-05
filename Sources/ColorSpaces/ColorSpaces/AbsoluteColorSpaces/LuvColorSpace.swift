//
//  LuvColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//



import Foundation

public struct LuvColorSpace: AbsoluteColorSpace {
    public var l, u, v: ColorUnit
    public var components: (ColorUnit, ColorUnit, ColorUnit) { (l, u, v) }

    public static let name = "CIE Luv"
    public static let standardWhitePoint = CIExyY.ColorSpace.AppleP3

    public init(l: ColorUnit, u: ColorUnit, v: ColorUnit) {
        self.l = l
        self.u = u
        self.v = v
    }

    public func toXYZ() -> XYZColorSpace {
        let whitePoint = Self.standardWhitePoint
        let (xw, yw, _) = (whitePoint.x, whitePoint.y, whitePoint.Y)
        let uw = 4 * xw / (xw + 15 * yw + 3)
        let vw = 9 * yw / (xw + 15 * yw + 3)

        let y = l > 8 ? yw * pow((l + 16) / 116, 3) : yw * l / 903.3

        let a: ColorUnit = (1/3) * (52 * l / (u + 13 * l * uw) - 1)
        let b: ColorUnit = -5 * y
        let c: ColorUnit = -1/3
        let d: ColorUnit = y * (39 * l / (v + 13 * l * vw) - 5)

        let x = (d - b) / (a - c)
        let z = x * a + b

        return XYZColorSpace(x: x, y: y, z: z)
    }

    public init(_ xyz: XYZColorSpace) {
        let whitePoint = Self.standardWhitePoint
        let (xw, yw, _) = (whitePoint.x, whitePoint.y, whitePoint.Y)
        let uw = 4 * xw / (xw + 15 * yw + 3)
        let vw = 9 * yw / (xw + 15 * yw + 3)

        let (x, y, z) = (xyz.x, xyz.y, xyz.z)
        let u = 4 * x / (x + 15 * y + 3)
        let v = 9 * y / (x + 15 * y + 3)

        let l = y > 0.008856 ? 116 * pow(y, 1/3) - 16 : 903.3 * y

        self.init(
            l: l,
            u: 13 * l * (u - uw),
            v: 13 * l * (v - vw)
        )
    }
}

extension AbsoluteColorSpace {
    public func toLuvColorSpace() -> LuvColorSpace {
        if let luv = self as? LuvColorSpace {
            return luv
        }
        return LuvColorSpace(self.toXYZ())
    }

    public init(luv: LuvColorSpace) {
        self.init(luv.toXYZ())
    }
}
