//
//  LuvColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//



import Foundation

public struct LuvColorSpace: AbsoluteColorSpace {
    // l: 0-1 (maps to 0-100)
    // u: 0-1 (maps to -100 to +100)
    // v: 0-1 (maps to -100 to +100)
    public var l, u, v: ColorUnit

    // Components are in the range 0-1:
    public var components: (ColorUnit, ColorUnit, ColorUnit) { (l, u, v) }

    public static let name = "CIE Luv"
    public static let standardWhitePoint = CIExyY.ColorSpace.AppleP3

    public init(l: ColorUnit, u: ColorUnit, v: ColorUnit) {
        self.l = l
        self.u = u
        self.v = v
    }

    public func toXYZ() -> XYZColorSpace {
        // Convert normalized values to typical Luv ranges
        let L = LuvColorSpace.denormalizeL(self.l)
        let u = LuvColorSpace.denormalizeUV(self.u)
        let v = LuvColorSpace.denormalizeUV(self.v)

        let whitePoint = Self.standardWhitePoint
        let (xw, yw, _) = (whitePoint.x, whitePoint.y, whitePoint.Y)
        let uw = 4 * xw / (xw + 15 * yw + 3)
        let vw = 9 * yw / (xw + 15 * yw + 3)

        let y = L > 8 ? yw * pow((L + 16) / 116, 3) : yw * L / 903.3

        let a: ColorUnit = (1/3) * (52 * L / (u + 13 * L * uw) - 1)
        let b: ColorUnit = -5 * y
        let c: ColorUnit = -1/3
        let d: ColorUnit = y * (39 * L / (v + 13 * L * vw) - 5)

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

        let newL = LuvColorSpace.normalizeL(l)
        let newU = LuvColorSpace.normalizeUV(13 * l * (u - uw))
        let newV = LuvColorSpace.normalizeUV(13 * l * (v - vw))

        self.init(l: newL, u: newU, v: newV)
    }

    // Helper methods to convert between 0-1 range and typical Luv ranges
    public static func normalizeL(_ L: ColorUnit) -> ColorUnit {
        return L / 100
    }

    public static func denormalizeL(_ l: ColorUnit) -> ColorUnit {
        return l * 100
    }

    public static func normalizeUV(_ uv: ColorUnit) -> ColorUnit {
        return (uv + 100) / 200
    }

    public static func denormalizeUV(_ uv: ColorUnit) -> ColorUnit {
        return uv * 200 - 100
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
