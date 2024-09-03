//
//  XYZColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public struct XYZColorSpace: LinearColorSpace {
    public var x, y, z: ColorUnit
    public var components: (ColorUnit, ColorUnit, ColorUnit) { (x, y, z) }

    public init(x: ColorUnit, y: ColorUnit, z: ColorUnit) {
        self.x = x
        self.y = y
        self.z = z
    }
}

extension XYZColorSpace: AbsoluteColorSpace {
    public func toXYZ() -> XYZColorSpace { self }

    public init(_ xyz: XYZColorSpace) {
        self = xyz
    }
}
