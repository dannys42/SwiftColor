//
//  HSLuvColorSpace.swift
//  Color
//
//  Created by Danny Sung on 9/2/24.
//
import Foundation

public struct HSLuvColorSpace: AbsoluteColorSpace {
    public var hue, saturation, lightness: ColorUnit
    public var components: (ColorUnit, ColorUnit, ColorUnit) { (hue, saturation, lightness) }

    public init(hue: ColorUnit, saturation: ColorUnit, lightness: ColorUnit) {
        self.hue = hue
        self.saturation = saturation
        self.lightness = lightness
    }

    public func toXYZ() -> XYZColorSpace {
        let tmp = toLuv()
        return luvToXyz(L: tmp.L, u: tmp.u, v: tmp.v)
    }

    public init(_ xyz: XYZColorSpace) {
        let luv = Self.xyzToLuv(X: xyz.x, Y: xyz.y, Z: xyz.z)
        self = Self.luvToHSLuv(L: luv.L, u: luv.u, v: luv.v)
    }

    private func toLuv() -> (L: ColorUnit, u: ColorUnit, v: ColorUnit) {
        if lightness > 99.9999999 {
            return (100, 0, 0)
        }
        if lightness < 0.00000001 {
            return (0, 0, 0)
        }
        
        let max = maxChromaForLH(L: lightness * 100, H: hue * 360)
        let C = max / 100 * saturation
        let H = hue * 360
        let Hrad = H / 360 * 2 * .pi
        
        return (L: lightness * 100, u: C * cos(Hrad), v: C * sin(Hrad))
    }

    private static func luvToHSLuv(L: ColorUnit, u: ColorUnit, v: ColorUnit) -> HSLuvColorSpace {
        if L > 99.9999999 {
            return HSLuvColorSpace(hue: 0, saturation: 0, lightness: 1)
        }
        if L < 0.00000001 {
            return HSLuvColorSpace(hue: 0, saturation: 0, lightness: 0)
        }
        
        let C = sqrt(u * u + v * v)
        let H = atan2(v, u) * 360 / (2 * .pi)
        let Hpos = H < 0 ? H + 360 : H
        let max = maxChromaForLH(L: L, H: Hpos)
        let S = C / max * 100
        
        return HSLuvColorSpace(hue: Hpos / 360, saturation: S / 100, lightness: L / 100)
    }

    private static func xyzToLuv(X: ColorUnit, Y: ColorUnit, Z: ColorUnit) -> (L: ColorUnit, u: ColorUnit, v: ColorUnit) {
        let L = yToL(Y: Y / refY)
        
        if L == 0 {
            return (0, 0, 0)
        }
        
        let varU = (4 * X) / (X + (15 * Y) + (3 * Z))
        let varV = (9 * Y) / (X + (15 * Y) + (3 * Z))
        let u = 13 * L * (varU - refU)
        let v = 13 * L * (varV - refV)
        
        return (L, u, v)
    }

    private func luvToXyz(L: ColorUnit, u: ColorUnit, v: ColorUnit) -> XYZColorSpace {
        if L == 0 {
            return XYZColorSpace(x: 0, y: 0, z: 0)
        }
        
        let varU = u / (13 * L) + refU
        let varV = v / (13 * L) + refV
        let Y = lToY(L: L) * refY
        let X = Y * 9 * varU / (4 * varV)
        let Z = Y * (12 - 3 * varU - 20 * varV) / (4 * varV)
        
        return XYZColorSpace(x: X, y: Y, z: Z)
    }

    private static func yToL(Y: ColorUnit) -> ColorUnit {
        if Y <= epsilon {
            return Y * kappa
        } else {
            return 116 * pow(Y, 1.0/3.0) - 16
        }
    }

    private func lToY(L: ColorUnit) -> ColorUnit {
        if L <= 8 {
            return L / kappa
        } else {
            return pow((L + 16) / 116, 3)
        }
    }
}

// Constants
let m = [
    [3.240969941904521, -1.537383177570093, -0.498610760293],
    [-0.96924363628087, 1.87596750150772, 0.041555057407175],
    [0.055630079696993, -0.20397695888897, 1.056971514242878]
]

let minv = [
    [0.41239079926595, 0.35758433938387, 0.18048078840183],
    [0.21263900587151, 0.71516867876775, 0.072192315360733],
    [0.019330818715591, 0.11919477979462, 0.95053215224966]
]

let refY = 1.0
let refU = 0.19783000664283
let refV = 0.46831999493879
let kappa = 903.2962962
let epsilon = 0.0088564516

// Utility functions
func dotProduct(_ a: [ColorUnit], _ b: [ColorUnit]) -> ColorUnit {
    return zip(a, b).map(*).reduce(0, +)
}

func lengthOfRayUntilIntersect(theta: ColorUnit, line: (slope: ColorUnit, intercept: ColorUnit)) -> ColorUnit {
    return line.intercept / (sin(theta) - line.slope * cos(theta))
}

func getBounds(L: ColorUnit) -> [(slope: ColorUnit, intercept: ColorUnit)] {
    let sub1 = pow(L + 16, 3) / 1560896
    let sub2 = sub1 > epsilon ? sub1 : L / kappa

    var result: [(slope: ColorUnit, intercept: ColorUnit)] = []

    for channel in 0..<3 {
        let m1 = m[channel][0]
        let m2 = m[channel][1]
        let m3 = m[channel][2]

        for t in [ColorUnit(0), ColorUnit(1)] {
            let top1 = (284517 * m1 - 94839 * m3) * sub2
            let top2 = (838422 * m3 + 769860 * m2 + 731718 * m1) * L * sub2 - 769860 * t * L
            let bottom = (632260 * m3 - 126452 * m2) * sub2 + 126452 * t

            result.append((slope: top1 / bottom, intercept: top2 / bottom))
        }
    }

    return result
}

func maxChromaForLH(L: ColorUnit, H: ColorUnit) -> ColorUnit {
    let hrad = H / 360 * 2 * .pi
    let bounds = getBounds(L: L)
    var min: ColorUnit = .infinity

    for bound in bounds {
        let length = lengthOfRayUntilIntersect(theta: hrad, line: bound)
        if length >= 0 && length < min {
            min = length
        }
    }

    return min
}

func maxSafeChromaForL(L: ColorUnit) -> ColorUnit {
    var min: ColorUnit = .infinity
    let burnoutPoints: [ColorUnit] = [0, 1 / 6, 1 / 3, 1 / 2, 2 / 3, 5 / 6, 1]

    for H in burnoutPoints {
        let chroma = maxChromaForLH(L: L, H: H * 360)
        if chroma < min {
            min = chroma
        }
    }

    return min
}
