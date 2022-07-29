//
//  TraceView.swift
//  Drawing
//
//  Created by Mohamd Bitar on 7/28/22.
//

import UIKit

final class TraceView: UIView {
    private var lines: [Line] = []
    private var _expectedPaths: [Path] = []
    private var expectedPathView: UIImageView!
    private let maxDistance: CGFloat = 10
    
    private var pendingPoints = [Path]()
    private var isComplete: Bool { return pendingPoints.isEmpty }
    
    var expectedPaths: [Path] {
        get { return _expectedPaths }
        set {
            _expectedPaths = newValue.map {
                let points = withAddedWayPoints(maxDistance: maxDistance, path: $0.points)
                return Path(points: points)
            }
            pendingPoints = _expectedPaths// Array(_expectedPaths.compactMap { $0.points }.joined())
            drawExpectedPaths(paths: newValue)
        }
    }
    
    required init?(coder: NSCoder) {
        expectedPathView = UIImageView(coder: coder)
        
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        expectedPathView = UIImageView()
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(expectedPathView)
        expectedPaths = getShape(totalPoints: 100)
        expectedPathView.alpha = 0.5
        
    }
    
//    func getShape(totalPoints: Int) -> [Path] {
//        var paths: [Path] = []
//        var points: [CGPoint] = []
//        let stroke1Path = UIBezierPath()
//
//
//        let point1 = CGPoint(x: 64.071, y: 22.197)
//        let newPointRatioX1 = (point1.x / 197) * 100
//        let newPointRatioY1 = (point1.y / 208) * 100
//
//        let newPointX1 = (newPointRatioX1 * self.frame.width) / 100
//        let newPointY1 = (newPointRatioY1 * self.frame.height) / 100
//        let newPoint1 = CGPoint(x: newPointX1, y: newPointY1)
//
//        let point2 = CGPoint(x: 22.428, y: 6.714)
//        let newPointRatioX2 = (point2.x / 197) * 100
//        let newPointRatioY2 = (point2.y / 208) * 100
//
//        let newPointX2 = (newPointRatioX2 * self.frame.width) / 100
//        let newPointY2 = (newPointRatioY2 * self.frame.height) / 100
//        let newPoint2 = CGPoint(x: newPointX2, y: newPointY2)
//
//
//        stroke1Path.move(to: newPoint1)
//        stroke1Path.addLine(to: newPoint2)
//
//        for i in 0...totalPoints {
//            let step: CGFloat = CGFloat(i) / CGFloat(totalPoints)
//            if let point = stroke1Path.point(at: step) {
//                points.append(point)
//            }
//        }
//        paths.append(Path(points: points))
//        return paths
//    }
    
    func getShape(totalPoints: Int) -> [Path] {
        var paths: [Path] = []
        var points: [CGPoint] = []
        let stroke1Path = UIBezierPath()
        stroke1Path.move(to: (CGPoint(x: 58, y: 111.503)))
        stroke1Path.addCurve(to: CGPoint(x: 148, y: 91.5031), controlPoint1: CGPoint(x: 69.5, y: 98.1698), controlPoint2: CGPoint(x: 103.6, y: 75.5031))
        stroke1Path.addCurve(to: CGPoint(x: 255.5, y: 111.503), controlPoint1: CGPoint(x: 192.4, y: 107.503), controlPoint2: CGPoint(x: 238.167, y: 111.503))
        stroke1Path.addCurve(to: CGPoint(x: 106, y: 184.503), controlPoint1: CGPoint(x: 210.833, y: 115.003), controlPoint2: CGPoint(x: 118.4, y: 134.503))
        stroke1Path.addCurve(to: CGPoint(x: 148, y: 316.503), controlPoint1: CGPoint(x: 94.964, y: 229.003), controlPoint2: CGPoint(x: 87, y: 267.503))
        stroke1Path.addCurve(to: CGPoint(x: 255.5, y: 288.003), controlPoint1: CGPoint(x: 196.8, y: 355.703), controlPoint2: CGPoint(x: 240, y: 313.837))
       
        for i in 0...totalPoints {
            let step: CGFloat = CGFloat(i) / CGFloat(totalPoints)
            if let point = stroke1Path.point(at: step) {
                let newPointRatioX = (point.x / 314) * 100
                let newPointRatioY = (point.y / 407) * 100
                
                let newPointX = (newPointRatioX * self.frame.width) / 100
                let newPointY = (newPointRatioY * self.frame.height) / 100
                let newPoint = CGPoint(x: newPointX, y: newPointY)
                points.append(newPoint)
            }
        }
        paths.append(Path(points: points))
        points = []
        return paths
    }
}

// MARK: WayPoints

extension TraceView {
    private func withAddedWayPoints(maxDistance: CGFloat, path: [CGPoint]) -> [CGPoint] {
        guard var last = path.first else { return path }
        
        var newPath = [CGPoint]()
        newPath.append(last)
        
        path[1..<path.count].forEach { point in
            let waypoints = calculateWaypoints(maxDistance: maxDistance, start: last, end: point)
            newPath.append(contentsOf: waypoints)
            newPath.append(point)
            last = point
        }
        
        return newPath
    }
    
    /// Returns the waypoints that should be inserted
    /// between two points so that the resulting
    /// points are less than the given distance apart.
    private func calculateWaypoints(maxDistance: CGFloat, start: CGPoint, end: CGPoint) -> [CGPoint] {
        let distance = getDistance(start: start, end: end)
        
        if distance < maxDistance {
            return []
        }
        
        // the points are too far apart, so we need to add
        // a waypoint
        let midPoint = getMidpoint(start: start, end: end)
        // then we want to check recursively get the waypoints
        // between the midpoint and the start and end
        
        return calculateWaypoints(maxDistance: maxDistance, start: start, end: midPoint) + [midPoint] + calculateWaypoints(maxDistance: maxDistance, start: midPoint, end: end)
    }
}

// MARK: - touchesMoved

extension TraceView {
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let end = touch.location(in: self)
            
            if pendingPoints.count > 0  {
                if let path = pendingPoints.first {
                    if path.points.count >= 2 {
                        let firstPoint = path.points[0]
                        let secondPoint = path.points[1]
                        
                        if (getDistance(start: end, end: firstPoint) < maxDistance * 2) {
                            let line = Line(start: firstPoint, end: secondPoint, outOfBounds: false)
                            self.lines.append(line)
                            
                            pendingPoints[0].points.remove(at: 0)
                            removePath(at: 0)
                        }
                    } else {
                        pendingPoints[0].points.removeAll()
                        removePath(at: 0)
                    }
                }
            }
            setNeedsDisplay()
        }
    }
     
    private func removePath(at index: Int) {
        if pendingPoints[index].points.count == 0 {
            pendingPoints.remove(at: index)
        }
    }
        
    private func isPointWithinBounds(_ point: CGPoint) -> Bool {
        return pendingPoints.contains { path in
            return path.points.contains { expectedPoint in
                return getDistance(start: point, end: expectedPoint) < maxDistance
            }
        }
    }
}

// MARK: - Drawing

extension TraceView {
    override func draw(_ rect: CGRect) {
        let overrideColor = isComplete ? UIColor.green.cgColor : nil
        guard let context = UIGraphicsGetCurrentContext() else {
            print("ERROR: no context available")
            return
        }
        
        // Background color
//        context.setFillColor(UIColor.white.cgColor)
//        context.fill(bounds)
        
        lines.forEach {
            drawLine(context: context, line: $0, overrideColor: overrideColor)
        }
        
        UIGraphicsEndImageContext()
    }
    
    private func drawExpectedPaths(paths: [Path]) {
        UIGraphicsBeginImageContext(expectedPathView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Could not retrieve context")
            return
        }
        
        context.setFillColor(UIColor.white.cgColor)
        context.fill(expectedPathView.bounds)
        
        paths.forEach {
            drawExpectedPath(context: context, path: $0)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        expectedPathView.image = image
    }
    
    private func drawExpectedPath(context: CGContext, path: Path) {
        let points = path.points
        
        guard var last = points.first else {
            print("There should be at least one point")
            return
        }
        
        print("Origin: \(self.frame.origin)")
        print("First: \(last)")
                
        context.setLineWidth(maxDistance * 2)
        context.setLineCap(.round)
        context.setStrokeColor(UIColor.gray.cgColor)
        points[1..<points.count].forEach { point in
            context.move(to: last)
            context.addLine(to: point)
            context.strokePath()
            last = point
        }

    }
    
    private func drawLine(context: CGContext, line: Line, overrideColor: CGColor?) {
        var color = UIColor.black.cgColor
        if line.outOfBounds {
            color = UIColor.red.cgColor
        } else if let overrideColor = overrideColor {
            color = overrideColor
        }
        
        context.setLineWidth(self.maxDistance * 2)
        context.setLineCap(.round)
        context.setStrokeColor(color)
        
        context.move(to: line.start)
        context.addLine(to: line.end)
        context.strokePath()
    }
}
