//
//  Path.swift
//  Drawing
//
//  Created by Mohamd Bitar on 7/28/22.
//

import UIKit

struct Path {
    var points: [CGPoint]
}

struct VectorBody {
    var points: [CGPoint]
    var type: PathType
    
    enum PathType: Int {
        case MOVE_TO = 0
        case LINE = 1
        case QUAD = 2
        case CUBIC = 3
        case HORIZONTAL = 4
        case VERTICAL = 5
        case CLOSE = 6
    }
}
