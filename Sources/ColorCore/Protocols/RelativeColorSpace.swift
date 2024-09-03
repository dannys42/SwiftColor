//
//  RelativeColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


protocol RelativeColorSpace: ColorSpace {
    static var standardWhitePoint: CIExyY { get }
    func toXYZ(relativeTo whitePoint: CIExyY) -> XYZColorSpace
    static func fromXYZ(_ xyz: XYZColorSpace, relativeTo whitePoint: CIExyY) -> Self
}