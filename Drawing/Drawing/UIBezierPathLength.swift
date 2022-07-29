//The MIT License (MIT)
//
//  Copyright (c) 2016 Jansel Valentin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

func bezierCurveLength(fromStart start: CGPoint, toEnd end: CGPoint, withControlPoint control: CGPoint) -> CGFloat {
    let kSubdivisions = 50
    let step = 1.0 / CGFloat(kSubdivisions)
    
    var totalLength: CGFloat = 0.0
    var prevPoint = start
    
    // starting from i = 1, since for i = 0 calculated point is equal to start point
    for i in 1...kSubdivisions {
        let t: CGFloat = CGFloat(i) * step
        
        let x1 = (1.0 - t) * (1.0 - t) * start.x
        let x2 = 2.0 * (1.0 - t) * t * control.x
        let x3 = t * t * end.x
        let x = x1 + x2 + x3
        
        let y1 = (1.0 - t) * (1.0 - t) * start.y
        let y2 = (2.0) * (1.0 - t) * t * control.y
        let y3 = t * t * end.y
        let y =  y1 + y2 + y3
        
        let diff: CGPoint = CGPoint(x: CGFloat(x) - prevPoint.x, y: y - prevPoint.y)
        
        totalLength += CGFloat(sqrt(diff.x * diff.x + diff.y * diff.y)) // Pythagorean
        
        prevPoint = CGPoint(x: x, y: y)
    }
    
    return totalLength
}
