//
//  PlatformIndepedentColorType.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//

#if canImport(UIKit)
import UIKit
public typealias PlatformColorType = UIColor
#elseif canImport(AppKit)
import AppKit
public typealias PlatformColorType = NSColor
#endif
