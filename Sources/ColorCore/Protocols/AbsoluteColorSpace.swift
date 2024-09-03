//
//  AbsoluteColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public protocol AbsoluteColorSpace: ColorSpace {
    func toXYZ() -> XYZColorSpace
    static func fromXYZ(_ xyz: XYZColorSpace) -> Self
}
