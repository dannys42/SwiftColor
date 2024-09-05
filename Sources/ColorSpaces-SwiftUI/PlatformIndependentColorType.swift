//
//  File.swift
//  Color
//
//  Created by Danny Sung on 9/4/24.
//

import SwiftUI
import ColorSpaces_AppKit_UIKit

extension Color {
    internal init(platformColor: PlatformColorType) {
#if canImport(UIKit)
        self.init(uiColor: platformColor)
#else
        self.init(platformColor)
#endif
    }
}
