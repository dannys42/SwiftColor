//
//  Matrix3x3.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


struct Matrix3x3 {
    var m: [[ColorUnit]]
    
    init(_ values: [[ColorUnit]]) {
        self.m = values
    }
    
    func multiply(_ v: [ColorUnit]) -> [ColorUnit] {
        return [
            m[0][0]*v[0] + m[0][1]*v[1] + m[0][2]*v[2],
            m[1][0]*v[0] + m[1][1]*v[1] + m[1][2]*v[2],
            m[2][0]*v[0] + m[2][1]*v[1] + m[2][2]*v[2]
        ]
    }
}
