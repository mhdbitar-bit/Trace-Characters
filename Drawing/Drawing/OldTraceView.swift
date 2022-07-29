////
////  TraceView.swift
////  Drawing
////
////  Created by Mohamd Bitar on 7/25/22.
//
//import UIKit
//
//struct Line {
//    let start: CGPoint
//    let end: CGPoint
//    let outOfBounds: Bool
//}
//
//struct Point {
//    let value: CGPoint
//    var isFill: Bool
//}
//
//struct Path {
//    var points: Array<Point>
//}
//
//class OldTraceView: UIView {
//    private var lines: Array<Line> = []
//    private var touchedPoint: CGPoint? = nil
//    private var _expectedPaths: Array<Path> = []
//    private var _expectedPathsWithWaypoints: Array<Path> = []
//    private let maxDistance: CGFloat = 20
//    private var pendingPoints: Array<Point> = []
//    private var isComplete: Bool { return pendingPoints.isEmpty }
//    
//    private var completeFirstTime: Bool = false
//    
//    var expectedPaths: Array<Path> {
//        get { return _expectedPathsWithWaypoints }
//        set {
//            _expectedPaths = newValue
//            _expectedPathsWithWaypoints = newValue.map {
//                let points = withAddedWayPoints(maxDistance: maxDistance, path: $0.points)
//                return Path(points: points)
//            }
//            pendingPoints = Array(_expectedPathsWithWaypoints.compactMap{$0.points}.joined())
//            drawExpectedPaths(paths: newValue)
//        }
//    }
//    
//    private func withAddedWayPoints(maxDistance: CGFloat, path: Array<Point>) -> Array<Point> {
//        
//        guard var last = path.first else {
//            return path
//        }
//        
//        var newPath = Array<Point>()
//        newPath.append(last)
//        
//        path[1..<path.count].forEach { pt in
//            let waypoints = calculateWaypoints(maxDistance: maxDistance, start: last.value, end: pt.value)
//            newPath.append(contentsOf: waypoints.map { Point(value: $0, isFill: false) })
//            newPath.append(pt)
//            last = pt
//        }
//        
//        return newPath
//    }
//    
//    /// Returns the waypoints that should be inserted
//    /// between two points so that the resulting
//    /// points are less than the given distance apart.
//    private func calculateWaypoints(maxDistance: CGFloat, start: CGPoint, end: CGPoint) -> Array<CGPoint> {
//        
//        let distance = getDistance(start: start, end: end)
//        
//        if distance < maxDistance {
//            return Array<CGPoint>()
//        }
//        
//        // the points are too far apart, so we need to add
//        // a waypoint
//        let midpoint = getMidpoint(start: start, end: end)
//        // then we want to check recursively get the waypoints
//        // between the midpoint and the start and end
//        
//        return
//            calculateWaypoints(maxDistance: maxDistance,
//                         start: start, end: midpoint) +
//            [midpoint] +
//            calculateWaypoints(maxDistance: maxDistance,
//                        start: midpoint, end: end)
//    }
//    
//    private func getMidpoint(start: CGPoint, end: CGPoint) -> CGPoint {
//        let x = (start.x + end.x) / 2.0
//        let y = (start.y + end.y) / 2.0
//        return CGPoint(x: x, y: y)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//    
//    private func commonInit() {
//        let strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        let stroke1Path = UIBezierPath()
//        stroke1Path.move(to: (CGPoint(x: 0.5, y: 34)))
//        stroke1Path.addCurve(to: CGPoint(x: 112, y: 7.99999), controlPoint1: CGPoint(x: 21.8333, y: 16.6667), controlPoint2: CGPoint(x: 74, y: -12.8))
//        stroke1Path.addCurve(to: CGPoint(x: 196, y: 34), controlPoint1: CGPoint(x: 150, y: 28.8), controlPoint2: CGPoint(x: 183.833, y: 34))
//        stroke1Path.miterLimit = 4
//        stroke1Path.lineCapStyle = .round
//        stroke1Path.lineJoinStyle = .round
//        stroke1Path.usesEvenOddFillRule = true
//        strokeColor.setStroke()
//        stroke1Path.lineWidth = 4
//        stroke1Path.stroke()
//        
////        expectedPaths.append(Path(points: stroke1Path.cgPath.points.map { Point(value: $0, isFill: false) } ))
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let start = touch.previousLocation(in: self)
//            let end = touch.location(in: self)
//            
//            let isOutOfBounds = ![start, end].allSatisfy(isPointWithinBounds)
//            let line = Line(start: start, end: end, outOfBounds: isOutOfBounds)
//            touchedPoint = start
//            print("line: \(line)")
//            
//            self.lines.append(line)
//            removeFromPending(pt: start)
//            removeFromPending(pt: end)
//        }
//        setNeedsDisplay()
//    }
//    
//    private func removeFromPending(pt: CGPoint) {
//        var toRemove: Set<Int> = []
//        pendingPoints.enumerated().forEach { entry in
//            let (offset, element) = entry
//            let distance = getDistance(start: element.value, end: pt)
//            if distance > maxDistance { return }
//            
//            toRemove.insert(offset)
//        }
//    
//        toRemove.forEach {
//            if $0 < pendingPoints.count {
//                pendingPoints.remove(at: $0)
//            }
//        }
//    }
//    
//    private func isPointWithinBounds(_ pt: CGPoint) -> Bool {
//        return expectedPaths.contains { path in
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
//    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else {
//            print("ERROR: no context available")
//            return
//        }
//        print("Touched: \(touchedPoint)")
//        
//        var points = expectedPaths[0].points
//        var prevPoint = points[0]
//        var touched: Bool = false
//        
//        for index in 1...points.count-1 {
//            if let touchedPoint = touchedPoint {
//                if !points[index].isFill && getDistance(start: points[index].value, end: touchedPoint) < 10 {
//                    context.setLineWidth(maxDistance * 2)
//                    context.setLineCap(.round)
//                    context.setStrokeColor(UIColor.black.cgColor)
//                    context.move(to: prevPoint.value)
//                    context.addLine(to: points[index].value)
//                    context.strokePath()
//                    points[index].isFill = true
//                    prevPoint = points[index]
//                    touched = true
//                    break
//                }
//                
//                prevPoint = points[index-1]
//                
//                
//    //            if !points[index].isFill && prevPoint.isFill {
//    //                points[index].isFill = true
//    //                prevPoint = points[index]
//    //                break
//    //            }
//            }
//        }
//        
//        if touched {
//            expectedPaths[0].points = points
//        }
//
//        
////        lines.forEach {
////            drawLine(context: context, line: $0, overrideColor: overrideColor)
////        }
//    }
//    
//    private func drawLine(context: CGContext, line: Line, overrideColor: CGColor?) {
//        if line.outOfBounds { return }
//        
//        var points = expectedPaths[0].points
//
//        for index in 1...points.count-1 {
//            var prevPoint = points[index-1]
//            
//            if !points[index].isFill && getDistance(start: points[index].value, end: line.start) == 0 {
//                context.setLineWidth(maxDistance * 2)
//                context.setLineCap(.round)
//                context.setStrokeColor(UIColor.black.cgColor)
//                context.move(to: prevPoint.value)
//                context.addLine(to: points[index].value)
//                context.strokePath()
//            }
//            
//            if !points[index].isFill && prevPoint.isFill {
//                print("Distance: \(getDistance(start: points[index].value, end: line.start))")
//                points[index].isFill = true
//                prevPoint = points[index]
//                break
//            }
//        }
//        
//        expectedPaths[0].points = points
//    }
//    
//    private func drawExpectedPaths(paths: Array<Path>) {
//        guard let context = UIGraphicsGetCurrentContext() else {
//                print("Could not retrieve context")
//                return
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
//}
