//
//  LinearSRGBColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public struct LinearSRGBColorSpace: RelativeColorSpace, LinearColorSpace {
    public var red, green, blue: ColorUnit
    public var components: (ColorUnit, ColorUnit, ColorUnit) { (red, green, blue) }

    public static let standardWhitePoint = CIExyY.D65WhitePoint

    private static let toXYZMatrix = Matrix3x3(
        (0.4124564, 0.3575761, 0.1804375),
        (0.2126729, 0.7151522, 0.0721750),
        (0.0193339, 0.1191920, 0.9503041)
    )

    private static let fromXYZMatrix = Matrix3x3(
        ( 3.2404542, -1.5371385, -0.4985314),
        (-0.9692660,  1.8760108,  0.0415560),
        ( 0.0556434, -0.2040259,  1.0572252)
    )

    init(red: ColorUnit, green: ColorUnit, blue: ColorUnit) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    public func toXYZ(relativeTo whitePoint: CIExyY) -> XYZColorSpace {
        let xyz = Self.toXYZMatrix.multiply((red, green, blue))
        return XYZColorSpace(x: xyz.0, y: xyz.1, z: xyz.2)
    }

    public init(_ xyz: XYZColorSpace, relativeTo whitePoint: CIExyY) {
        let rgb = Self.fromXYZMatrix.multiply((xyz.x, xyz.y, xyz.z))
        self.init(red: rgb.0, green: rgb.1, blue: rgb.2)
    }
}

extension RelativeColorSpace {
    public func toLinearSRGBColorSpace(relativeTo whitePoint: CIExyY = Self.standardWhitePoint) -> LinearSRGBColorSpace {
        if let linearSRGB = self as? LinearSRGBColorSpace {
            return linearSRGB
        }
        return LinearSRGBColorSpace(self.toXYZ(relativeTo: whitePoint), relativeTo: whitePoint)
    }

    public init(linearSRGB: LinearSRGBColorSpace, relativeTo whitePoint: CIExyY = Self.standardWhitePoint) {
        self.init(linearSRGB.toXYZ(relativeTo: whitePoint), relativeTo: whitePoint)
    }
}
