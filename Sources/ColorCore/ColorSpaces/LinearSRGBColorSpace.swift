//
//  LinearSRGBColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


struct LinearSRGBColorSpace: RelativeColorSpace, LinearColorSpace {
    var red, green, blue: ColorUnit
    var components: (ColorUnit, ColorUnit, ColorUnit) { (red, green, blue) }

    static let standardWhitePoint = CIExyY.D65WhitePoint

    private static let toXYZMatrix = Matrix3x3([
        [0.4124564, 0.3575761, 0.1804375],
        [0.2126729, 0.7151522, 0.0721750],
        [0.0193339, 0.1191920, 0.9503041]
    ])

    private static let fromXYZMatrix = Matrix3x3([
        [ 3.2404542, -1.5371385, -0.4985314],
        [-0.9692660,  1.8760108,  0.0415560],
        [ 0.0556434, -0.2040259,  1.0572252]
    ])

    func toXYZ(relativeTo whitePoint: CIExyY) -> XYZColorSpace {
        let xyz = Self.toXYZMatrix.multiply([red, green, blue])
        return XYZColorSpace(x: xyz[0], y: xyz[1], z: xyz[2])
    }

    static func fromXYZ(_ xyz: XYZColorSpace, relativeTo whitePoint: CIExyY) -> LinearSRGBColorSpace {
        let rgb = Self.fromXYZMatrix.multiply([xyz.x, xyz.y, xyz.z])
        return LinearSRGBColorSpace(red: rgb[0], green: rgb[1], blue: rgb[2])
    }
}
