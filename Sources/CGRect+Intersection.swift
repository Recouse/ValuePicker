//
//  CGRect+Intersection.swift
//  ValuePicker
//
//  Created by Firdavs Khaydarov on 25/01/2025.
//

import UIKit

// Taken from https://stackoverflow.com/a/51076570/7844080

extension CGRect {
    func intersectionPercentage(_ otherRect: CGRect) -> CGFloat {
        if !intersects(otherRect) { return 0 }
        let intersectionRect = intersection(otherRect)
        if intersectionRect == self || intersectionRect == otherRect { return 100 }
        let intersectionArea = intersectionRect.width * intersectionRect.height
        let area = width * height
        let otherRectArea = otherRect.width * otherRect.height
        let sumArea = area + otherRectArea
        let sumAreaNormalized = sumArea / 2.0
        return intersectionArea / sumAreaNormalized * 100.0
    }
}
