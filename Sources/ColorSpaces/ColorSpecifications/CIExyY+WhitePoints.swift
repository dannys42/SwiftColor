//
//  File.swift
//  Color
//
//  Created by Danny Sung on 9/3/24.
//

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
        public static let F2 = CIExyY(x: 0.3721, y: 0.3751, Y: 1.0)  // Cool white fluorescent
         public static let F7 = CIExyY(x: 0.3129, y: 0.3292, Y: 1.0)  // Daylight fluorescent, D65 simulator
         public static let F11 = CIExyY(x: 0.3805, y: 0.3769, Y: 1.0)  // Philips TL84, narrow-band fluorescent

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
        public static let ACES = CIExyY(x: 0.32168, y: 0.33767, Y: 1.0)  // Academy Color Encoding System
        public static let CIE_RGB = CIExyY(x: 0.3333, y: 0.3333, Y: 1.0)  // CIE RGB color space
        public static let BT2020 = StandardIlluminant.D65  // ITU-R BT.2020 for UHDTV
    }

    // Device-specific White Points
    public struct DeviceWhitePoints {
        public static let iPhone12Pro = ColorSpace.AppleP3
        public static let iPadPro2021 = ColorSpace.AppleP3
        public static let MacBookPro2021 = ColorSpace.AppleP3
        public static let iMacPro = ColorSpace.AppleP3
    }

    // Historical and Regional White Points
    public struct HistoricalAndRegionalWhitePoints {
        public static let CIE_1931 = CIExyY(x: 0.3101, y: 0.3162, Y: 1.0)  // Original CIE 1931 white point
        public static let JapaneseDBTV = CIExyY(x: 0.3127, y: 0.3293, Y: 1.0)  // Japanese digital broadcast TV
    }

    // Industry-specific White Points
    public struct Industry {
        public static let printing = StandardIlluminant.D50  // Common in printing industry
        public static let photography = StandardIlluminant.D65  // Often used in digital photography
        public static let cinema = ColorSpace.DCI_P3  // Digital Cinema Initiative standard
        public static let videoProduction = StandardIlluminant.D65  // Common in video production
        public static let textileIndustry = StandardIlluminant.D65  // Often used in textile color management
    }

    // Common Light Sources
    public struct LightSource {
        public static let incandescent = CIExyY(x: 0.4476, y: 0.4074, Y: 1.0)
        public static let halogen = CIExyY(x: 0.4234, y: 0.3990, Y: 1.0)
        public static let fluorescent = CIExyY(x: 0.3131, y: 0.3371, Y: 1.0)
        public static let coolWhiteLED = CIExyY(x: 0.2883, y: 0.3101, Y: 1.0)
        public static let warmWhiteLED = CIExyY(x: 0.4585, y: 0.4103, Y: 1.0)
        public static let directSunlight = CIExyY(x: 0.3324, y: 0.3474, Y: 1.0)
        public static let overcastSky = CIExyY(x: 0.3101, y: 0.3162, Y: 1.0)
        public static let clearBlueSky = CIExyY(x: 0.2471, y: 0.2530, Y: 1.0)
        public static let candle = CIExyY(x: 0.5268, y: 0.4200, Y: 1.0)
        public static let sodium = CIExyY(x: 0.5669, y: 0.4231, Y: 1.0)
        public static let metalHalide = CIExyY(x: 0.3723, y: 0.3768, Y: 1.0)
        public static let highPressureSodium = CIExyY(x: 0.5216, y: 0.4356, Y: 1.0)
        public static let tungstenHalogen = CIExyY(x: 0.4478, y: 0.4070, Y: 1.0)
        public static let carbonArc = CIExyY(x: 0.3101, y: 0.3162, Y: 1.0)
        public static let xenon = CIExyY(x: 0.3249, y: 0.3614, Y: 1.0)
    }

    // Specialized Application White Points
    public struct SpecializedApplicationWhitePoints {
        public static let medicalImaging = StandardIlluminant.D65  // Common in medical displays
        public static let astronomicalImaging = StandardIlluminant.D65  // Often used in astronomical imaging
        public static let colorimetryLab = StandardIlluminant.D50  // Common in colorimetry laboratories
    }
}
