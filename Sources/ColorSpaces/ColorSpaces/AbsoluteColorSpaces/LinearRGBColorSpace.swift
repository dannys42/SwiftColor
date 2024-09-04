//
//  LinearRGBColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public struct LinearRGBColorSpace: AbsoluteColorSpace {
    public var red, green, blue: ColorUnit
    public var components: (ColorUnit, ColorUnit, ColorUnit) { (red, green, blue) }

    static let name = "Linear RGB"
    
    // Matrix for converting from XYZ to Linear RGB (sRGB primaries)
    private static let xyzToRgbMatrix = Matrix3x3(
        (3.2404542, -1.5371385, -0.4985314),
        (-0.9692660,  1.8760108,  0.0415560),
        (0.0556434, -0.2040259,  1.0572252)
    )

    // Matrix for converting from Linear RGB to XYZ (sRGB primaries)
    private static let rgbToXyzMatrix = Matrix3x3(
        (0.4124564,  0.3575761,  0.1804375),
        (0.2126729,  0.7151522,  0.0721750),
        (0.0193339,  0.1191920,  0.9503041)
    )


    public init(red: ColorUnit, green: ColorUnit, blue: ColorUnit) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    public init(_ xyz: XYZColorSpace) {
        let rgb = Self.xyzToRgbMatrix.multiply((xyz.x, xyz.y, xyz.z))
        self.init(red: rgb.0, green: rgb.1, blue: rgb.2)
    }
    
    public func toXYZ() -> XYZColorSpace {
        let xyz = Self.rgbToXyzMatrix.multiply((red, green, blue))
        return XYZColorSpace(x: xyz.0, y: xyz.1, z: xyz.2)
    }
    
    func clamped() -> Self {
        LinearRGBColorSpace(
            red: red.clamped(to: 0...1),
            green: green.clamped(to: 0...1),
            blue: blue.clamped(to: 0...1)
        )
    }
}

extension AbsoluteColorSpace {
    public func toLinearRGBColorSpace() -> LinearRGBColorSpace {
        if let linearRGB = self as? LinearRGBColorSpace {
            return linearRGB
        }
        return LinearRGBColorSpace(self.toXYZ())
    }

    public init(linearRGB: LinearRGBColorSpace) {
        self.init(linearRGB.toXYZ())
    }


    public func withLinearRGB(red: ColorUnit?=nil, green: ColorUnit?=nil, blue: ColorUnit?=nil) -> LinearRGBColorSpace {

        var linearRGB = self.toLinearRGBColorSpace()
        if let red {
            linearRGB.red = red
        }
        if let green {
            linearRGB.green = green
        }
        if let blue {
            linearRGB.blue = blue
        }
        return linearRGB
    }
}
