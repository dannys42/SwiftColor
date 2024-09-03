//
//  Matrix3x3.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


import Foundation
#if canImport(Accelerate)
import Accelerate
#endif

struct Matrix3x3 {
    private var matrix: (ColorUnit, ColorUnit, ColorUnit, ColorUnit, ColorUnit, ColorUnit, ColorUnit, ColorUnit, ColorUnit)

    init(_ row1: (ColorUnit, ColorUnit, ColorUnit),
         _ row2: (ColorUnit, ColorUnit, ColorUnit),
         _ row3: (ColorUnit, ColorUnit, ColorUnit)) {
        matrix = (row1.0, row1.1, row1.2,
                  row2.0, row2.1, row2.2,
                  row3.0, row3.1, row3.2)
    }

    func multiply(_ v: (ColorUnit, ColorUnit, ColorUnit)) -> (ColorUnit, ColorUnit, ColorUnit) {
        #if canImport(Accelerate)
        var result: (ColorUnit, ColorUnit, ColorUnit) = (0, 0, 0)
        let vector = [v.0, v.1, v.2]
        let matrixArray = [matrix.0, matrix.1, matrix.2,
                           matrix.3, matrix.4, matrix.5,
                           matrix.6, matrix.7, matrix.8]

        vDSP_mmulD(matrixArray, 1, vector, 1, &result.0, 1, 3, 3, 1)
        return result
        #else
        return (
            matrix.0 * v.0 + matrix.1 * v.1 + matrix.2 * v.2,
            matrix.3 * v.0 + matrix.4 * v.1 + matrix.5 * v.2,
            matrix.6 * v.0 + matrix.7 * v.1 + matrix.8 * v.2
        )
        #endif
    }
}
