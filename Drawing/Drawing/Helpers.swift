//
//  Helpers.swift
//  Drawing
//
//  Created by Mohamd Bitar on 7/28/22.
//

import UIKit
import BezierPathLength

func getDistance(start: CGPoint, end: CGPoint) -> CGFloat {
    let dx = start.x - end.x
    let dy = start.y - end.y
    let distance = sqrt(dx * dx + dy * dy)
    return distance
}

func getMidpoint(start: CGPoint, end: CGPoint) -> CGPoint {
    let x = (start.x + end.x) / 2.0
    let y = (start.y + end.y) / 2.0
    return CGPoint(x: x, y: y)
}

// ح




