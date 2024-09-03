//
//  RelativeColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public protocol RelativeColorSpace: ColorSpace {
    static var standardWhitePoint: CIExyY { get }

    func toXYZ(relativeTo whitePoint: CIExyY) -> XYZColorSpace
    init(_ xyz: XYZColorSpace, relativeTo whitePoint: CIExyY)
}
