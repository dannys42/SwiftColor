//
//  ColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


protocol ColorSpace {
    associatedtype Components
    var components: Components { get }
}

