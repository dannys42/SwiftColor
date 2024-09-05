//
//  AbsoluteColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public protocol AbsoluteColorSpace: ColorSpace {
    static var standardWhitePoint: CIExyY { get }

    func toXYZ() -> XYZColorSpace
    init(_ xyz: XYZColorSpace)
}
