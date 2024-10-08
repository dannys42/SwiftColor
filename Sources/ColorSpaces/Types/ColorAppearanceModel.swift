//
//  ColorAppearanceModel.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public protocol ColorAppearanceModel {
    func adjust(color: any LinearColorSpace, from sourceIlluminant: CIExyY, to destinationIlluminant: CIExyY, sourceAdaptingLuminance: ColorUnit, destinationAdaptingLuminance: ColorUnit) -> any LinearColorSpace
}
