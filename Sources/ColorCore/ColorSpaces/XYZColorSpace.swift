//
//  XYZColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


struct XYZColorSpace: AbsoluteColorSpace, LinearColorSpace {
    var x, y, z: ColorUnit
    var components: (ColorUnit, ColorUnit, ColorUnit) { (x, y, z) }

    func toXYZ() -> XYZColorSpace { self }
    static func fromXYZ(_ xyz: XYZColorSpace) -> XYZColorSpace { xyz }
}