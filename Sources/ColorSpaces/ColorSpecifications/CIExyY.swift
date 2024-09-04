//
//  CIExyY.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//


public struct CIExyY {
    public var x, y, Y: ColorUnit
}

// MARK: White Points
extension CIExyY {
    //    public static let D65WhitePoint = CIExyY(x: 0.3127, y: 0.3290, Y: 1.0)
    //    public static let AdobeRGBWhitePoint = D65WhitePoint // D65, same as sRGB
    //    public static let P3D65WhitePoint = D65WhitePoint // D65, same as sRGB
    //
    //    public static let D50WhitePoint = CIExyY(x: 0.34567, y: 0.35850, Y: 1.0)
    //    public static let D55WhitePoint = CIExyY(x: 0.33242, y: 0.34743, Y: 1.0)
    //    public static let D75WhitePoint = CIExyY(x: 0.29902, y: 0.31485, Y: 1.0)
    //
    //    public static let IlluminantA = CIExyY(x: 0.44757, y: 0.40745, Y: 1.0)
    //    public static let IlluminantB = CIExyY(x: 0.34842, y: 0.35161, Y: 1.0)
    //    public static let IlluminantC = CIExyY(x: 0.31006, y: 0.31616, Y: 1.0)
    //    public static let IlluminantE = CIExyY(x: 1/3, y: 1/3, Y: 1.0)
    //
    //    public static let DCI_P3WhitePoint = CIExyY(x: 0.314, y: 0.351, Y: 1.0)
    //    public static let NTSC1953WhitePoint = CIExyY(x: 0.31006, y: 0.31616, Y: 1.0) // Illuminant C
    //
    //    // Common light sources
    //    public static let incandescent = CIExyY(x: 0.4476, y: 0.4074, Y: 1.0)
    //    public static let fluorescent = CIExyY(x: 0.3131, y: 0.3371, Y: 1.0)
    //    public static let coolWhiteLED = CIExyY(x: 0.2883, y: 0.3101, Y: 1.0)
    //    public static let warmWhiteLED = CIExyY(x: 0.4585, y: 0.4103, Y: 1.0)
    //    public static let halogen = CIExyY(x: 0.4234, y: 0.3990, Y: 1.0)
    //    public static let directSunlight = CIExyY(x: 0.3324, y: 0.3474, Y: 1.0)
    //    public static let overcastSky = CIExyY(x: 0.3101, y: 0.3162, Y: 1.0)
    //    public static let clearBlueSky = CIExyY(x: 0.2471, y: 0.2530, Y: 1.0)
    //    public static let candle = CIExyY(x: 0.5268, y: 0.4200, Y: 1.0)
    //    public static let sodium = CIExyY(x: 0.5669, y: 0.4231, Y: 1.0)

    // Standard Illuminants (CIE defined)
    public struct StandardIlluminant {
        public static let A = CIExyY(x: 0.44757, y: 0.40745, Y: 1.0)  // Incandescent/tungsten
        public static let B = CIExyY(x: 0.34842, y: 0.35161, Y: 1.0)  // Direct sunlight at noon (deprecated)
        public static let C = CIExyY(x: 0.31006, y: 0.31616, Y: 1.0)  // Average daylight (deprecated)
        public static let D50 = CIExyY(x: 0.34567, y: 0.35850, Y: 1.0)  // Horizon light
        public static let D55 = CIExyY(x: 0.33242, y: 0.34743, Y: 1.0)  // Mid-morning/mid-afternoon daylight
        public static let D65 = CIExyY(x: 0.3127, y: 0.3290, Y: 1.0)   // Noon daylight
        public static let D75 = CIExyY(x: 0.29902, y: 0.31485, Y: 1.0)  // North sky daylight
        public static let E = CIExyY(x: 1/3, y: 1/3, Y: 1.0)  // Equal energy
        public static let F1 = CIExyY(x: 0.3131, y: 0.3371, Y: 1.0)  // Daylight fluorescent
        // Add more F series if needed (F2-F12 represent different fluorescent lamps)
    }

    // Color Space White Points
    public struct ColorSpace {
        public static let sRGB = StandardIlluminant.D65
        public static let AdobeRGB = StandardIlluminant.D65
        public static let AppleP3 = StandardIlluminant.D65
        public static let NTSC1953 = StandardIlluminant.C
        public static let DCI_P3 = CIExyY(x: 0.314, y: 0.351, Y: 1.0)
        public static let ProPhotoRGB = StandardIlluminant.D50
    }

    // Industry-specific White Points
    public struct Industry {
        public static let printing = StandardIlluminant.D50  // Common in printing industry
        public static let photography = StandardIlluminant.D65  // Often used in digital photography
        public static let cinema = ColorSpace.DCI_P3  // Digital Cinema Initiative standard
    }

    // Common light sources
    public struct LightSource {
        public static let incandescent = CIExyY(x: 0.4476, y: 0.4074, Y: 1.0)
        public static let fluorescent = CIExyY(x: 0.3131, y: 0.3371, Y: 1.0)
        public static let coolWhiteLED = CIExyY(x: 0.2883, y: 0.3101, Y: 1.0)
        public static let warmWhiteLED = CIExyY(x: 0.4585, y: 0.4103, Y: 1.0)
        public static let halogen = CIExyY(x: 0.4234, y: 0.3990, Y: 1.0)
        public static let directSunlight = CIExyY(x: 0.3324, y: 0.3474, Y: 1.0)
        public static let overcastSky = CIExyY(x: 0.3101, y: 0.3162, Y: 1.0)
        public static let clearBlueSky = CIExyY(x: 0.2471, y: 0.2530, Y: 1.0)
        public static let candle = CIExyY(x: 0.5268, y: 0.4200, Y: 1.0)
        public static let sodium = CIExyY(x: 0.5669, y: 0.4231, Y: 1.0)
    }
}
