# SwiftColor
UI agnostic color management for Swift



# Design Summary

Summary of the key points in this color management system design:

## Protocol Hierarchy:


ColorSpace: Base protocol for all color spaces
LinearColorSpace: Protocol for linear color spaces
AbsoluteColorSpace: Protocol for absolute color spaces (e.g., XYZ, Lab)
RelativeColorSpace: Protocol for relative color spaces (e.g., sRGB, Adobe RGB)


## Key Structures:


ColorUnit: Typealias for Double, used for color component values
CIExyY: Structure for representing chromaticity coordinates and luminance
Matrix3x3: Utility structure for 3x3 matrix operations


## Color Space Implementations:


Each color space (e.g., XYZ, sRGB, AdobeRGB, HSL, HSLuv) is implemented as a struct conforming to the appropriate protocol(s)
Linear and non-linear versions of RGB color spaces are separate structs
Each color space includes methods for conversion to/from XYZ


## ColorSpecification:


Generic struct that encapsulates a color space, white point, and illuminant
Provides a convert method for transforming between color spaces


## Chromatic Adaptation and Color Appearance Model:


Protocols defined for chromatic adaptation and color appearance models
Default implementations provided (e.g., Bradford adaptation, simple CAM)


## Key Features:


Clear separation between linear and non-linear color spaces
Distinction between absolute and relative color spaces
Fully spelled-out color component names (e.g., red, green, blue instead of r, g, b)
Support for different white points and illuminants
Accurate implementations of complex color spaces (e.g., HSLuv)


## Utility Methods:


Conversion between 8-bit integer and floating-point representations
Clamping methods to ensure color values are within valid ranges
Direct conversions between common color spaces (e.g., sRGB to Adobe RGB)


## Flexibility and Extensibility:


Easy to add new color spaces by conforming to existing protocols
Chromatic adaptation and color appearance models can be easily swapped or extended

This design provides a robust, flexible, and accurate foundation for color management, allowing for precise color space conversions and manipulations while maintaining type safety and clarity in the codebase.
