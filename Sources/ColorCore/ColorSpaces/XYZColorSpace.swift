//
//  XYZColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public struct XYZColorSpace: AbsoluteColorSpace, LinearColorSpace {
    public var x, y, z: ColorUnit
    public var components: (ColorUnit, ColorUnit, ColorUnit) { (x, y, z) }

    public func toXYZ() -> XYZColorSpace { self }
    public static func fromXYZ(_ xyz: XYZColorSpace) -> XYZColorSpace { xyz }
}
