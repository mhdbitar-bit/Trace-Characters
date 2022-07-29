//
//  CoffeeView.swift
//  Drawing
//
//  Created by Mohamd Bitar on 7/26/22.
//

import UIKit
import BezierPathLength

class CoffeeView: UIView {
//    var renderFirst: Bool = true
//    
//    var startPoint: CGPoint?
//    var endPoint: CGPoint?
//
//    private var _expectedPathsWithWaypoints = [Path]()
//    private var _expectedPaths = [Path]()
//    private let maxDistance: CGFloat = 20
//    private let totalPoints = 100
//    
//    var paths: [Path] {
//        get { return _expectedPathsWithWaypoints }
//        set {
//            drawExpectedPaths(paths: newValue)
//        }
//    }
//    
//    private func drawExpectedPaths(paths: [Path]) {
//        guard let context = UIGraphicsGetCurrentContext() else {
//            print("Could not retrieve context")
//            return
//        }
//        
//        paths.forEach {
//            drawExpectedPath(context: context, path: $0)
//        }
//    }
//    
//    private func drawExpectedPath(context: CGContext, path: Path) {
//        let points = path.points
//        
//        guard var last = points.first else {
//            print("There should be at least one point")
//            return
//        }
//        
//        context.setLineWidth(maxDistance * 2)
//        context.setLineCap(.round)
//        context.setStrokeColor(UIColor.gray.cgColor)
//        points[1..<points.count].forEach { pt in
//            context.move(to: last.value)
//            context.addLine(to: pt.value)
//            context.strokePath()
//            last = pt
//        }
//    }
//    
//    override func draw(_ rect: CGRect) {
//        if renderFirst {
//            drawExpectedPaths(paths: getShape(totalPoints: 100))
//            renderFirst = false
//        }
//        
//        guard let context = UIGraphicsGetCurrentContext() else {
//            print("Could not retrieve context")
//            return
//        }
//        
//        if let startPoint = startPoint, let endPoint = endPoint {
//            drawLine(context: context, point1: startPoint, point2: endPoint)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let point = touches.first {
//            startPoint = point.location(in: self)
//        }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let point = touches.first {
//            endPoint = point.location(in: self)
//        }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let start = touch.previousLocation(in: self)
//            let end = touch.location(in: self)
//            
//            let isOutOfBounds = ![start, end].allSatisfy(isPointWithinBounds)
//            print(isOutOfBounds)
//            
//            if !isOutOfBounds {
//               
//            }
//            
//        }
//        setNeedsDisplay()
//    }
//    
//    private func isPointWithinBounds(_ pt: CGPoint) -> Bool {
//        return paths.contains { path in
//            return path.points.contains { ept in
//                return getDistance(start: pt, end: ept.value) < maxDistance
//            }
//        }
//    }
//    
//    private func getDistance(start: CGPoint, end: CGPoint) -> CGFloat {
//        let dx = start.x - end.x
//        let dy = start.y - end.y
//        let distance = sqrt(dx * dx + dy * dy)
//        return distance
//    }
//    
//    private func drawLine(context: CGContext, point1: CGPoint, point2: CGPoint) {
//        context.setLineWidth(maxDistance * 2)
//        context.setLineCap(.round)
//        context.setStrokeColor(UIColor.black.cgColor)
//        context.move(to: point1)
//        context.addLine(to: point2)
//        context.strokePath()
//    }
//}
//
//extension CoffeeView {
//    private func getShape(totalPoints: Int) -> [Path] {
//        var paths: [Path] = []
//        var points: [Point] = []
//        let stroke1Path = UIBezierPath()
//        stroke1Path.move(to: (CGPoint(x: 0.5, y: 34)))
//        stroke1Path.addCurve(to: CGPoint(x: 112, y: 7.99999), controlPoint1: CGPoint(x: 21.8333, y: 16.6667), controlPoint2: CGPoint(x: 74, y: -12.8))
//        stroke1Path.addCurve(to: CGPoint(x: 196, y: 34), controlPoint1: CGPoint(x: 150, y: 28.8), controlPoint2: CGPoint(x: 183.833, y: 34))
//        
//        for i in 0...totalPoints {
//            let step: CGFloat = CGFloat(i) / CGFloat(totalPoints)
//            if let point = stroke1Path.point(at: step) {
//                points.append(Point(value: point, isFill: false))
//            }
//        }
//        paths.append(Path(points: points))
//        points = []
//        
//        let stroke2Path = UIBezierPath()
//        stroke2Path.move(to: CGPoint(x: 196, y: 35))
//        stroke2Path.addCurve(to: CGPoint(x: 49, y: 123), controlPoint1: CGPoint(x: 149.667, y: 37.1667), controlPoint2: CGPoint(x: 55.4, y: 57.8))
//        stroke2Path.addCurve(to: CGPoint(x: 105.5, y: 207), controlPoint1: CGPoint(x: 42.6, y: 188.2), controlPoint2: CGPoint(x: 84, y: 206.167))
//        stroke2Path.miterLimit = 4
//        stroke2Path.addCurve(to: CGPoint(x: 196, y: 184.5), controlPoint1: CGPoint(x: 127.167, y: 207.833), controlPoint2: CGPoint(x: 175.6, y: 204.5))
//        
//        for i in 0...totalPoints {
//            let step: CGFloat = CGFloat(i) / CGFloat(totalPoints)
//            if let point = stroke2Path.point(at: step) {
//                points.append(Point(value: point, isFill: false))
//            }
//        }
//        paths.append(Path(points: points))
//        
//        return paths
//    }
}
