//
//  ChromaticAdaptation.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//

public protocol ChromaticAdaptation {
    func adapt(color: LinearColorSpace, from sourceWhitePoint: CIExyY, to destinationWhitePoint: CIExyY) -> LinearColorSpace
}
