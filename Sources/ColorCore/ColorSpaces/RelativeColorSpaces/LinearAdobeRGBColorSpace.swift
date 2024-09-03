//
//  LinearAdobeRGBColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public struct LinearAdobeRGBColorSpace: RelativeColorSpace, LinearColorSpace {
    public var red, green, blue: ColorUnit
    public var components: (ColorUnit, ColorUnit, ColorUnit) { (red, green, blue) }

    public static let standardWhitePoint = CIExyY.AdobeRGBWhitePoint

    private static let toXYZMatrix = Matrix3x3([
        [0.5767309, 0.1855540, 0.1881852],
        [0.2973769, 0.6273491, 0.0752741],
        [0.0270343, 0.0706872, 0.9911085]
    ])
    
    private static let fromXYZMatrix = Matrix3x3([
        [ 2.0413690, -0.5649464, -0.3446944],
        [-0.9692660,  1.8760108,  0.0415560],
        [ 0.0134474, -0.1183897,  1.0154096]
    ])

    init(red: ColorUnit, green: ColorUnit, blue: ColorUnit) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    public func toXYZ(relativeTo whitePoint: CIExyY) -> XYZColorSpace {
        let xyz = Self.toXYZMatrix.multiply([red, green, blue])
        return XYZColorSpace(x: xyz[0], y: xyz[1], z: xyz[2])
    }

    public init(_ xyz: XYZColorSpace, relativeTo whitePoint: CIExyY) {
        let rgb = Self.fromXYZMatrix.multiply([xyz.x, xyz.y, xyz.z])
        self = LinearAdobeRGBColorSpace(red: rgb[0], green: rgb[1], blue: rgb[2])
    }
}

extension RelativeColorSpace {
    public func toLinearAdobeRGBColorSpace(relativeTo whitePoint: CIExyY = Self.standardWhitePoint) -> LinearAdobeRGBColorSpace {
        if let linearAdobeRGB = self as? LinearAdobeRGBColorSpace {
            return linearAdobeRGB
        }
        return LinearAdobeRGBColorSpace(self.toXYZ(relativeTo: whitePoint), relativeTo: whitePoint)
    }

    public init(linearAdobeRGB: LinearAdobeRGBColorSpace, relativeTo whitePoint: CIExyY = Self.standardWhitePoint) {
        self.init(linearAdobeRGB.toXYZ(relativeTo: whitePoint), relativeTo: whitePoint)
    }
}
