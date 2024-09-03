//
//  CIExyY.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public struct CIExyY {
    public var x, y, Y: ColorUnit
}

extension CIExyY {
    public static let D65WhitePoint = CIExyY(x: 0.3127, y: 0.3290, Y: 1.0)
    public static let AdobeRGBWhitePoint = D65WhitePoint // D65, same as sRGB

}
