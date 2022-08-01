//
//  TraceView.swift
//  Drawing
//
//  Created by Mohamd Bitar on 7/28/22.
//

import UIKit

//https://polyglot.jamie.ly/programming/2019/04/01/tracer-a-swift-drawing-view.html
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
            pendingPoints = _expectedPaths
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
        let path1 = "M133.344 165.436C152.6 143.11 181.639 110.878 248.043 153.72C299.951 187.208 399.022 187.208 428.045 187.208"
        let path2 = "M428.045 187.208C353.254 193.069 210.934 249.937 177.717 309.443C157.623 345.438 135.989 469.031 248.043 530.469C299.951 558.929 402.092 526.003 428.045 482.747"
        let path3 = "M294.5 385.5C294.5 386.052 294.052 386.5 293.5 386.5C292.948 386.5 292.5 386.052 292.5 385.5C292.5 384.948 292.948 384.5 293.5 384.5C294.052 384.5 294.5 384.948 294.5 385.5Z"
        
        [path1, path2, path3].forEach {
            expectedPaths.append(contentsOf: getShape(from: getPoints(path: $0), for: self, totalPoints: 100))
        }
        
//        expectedPaths = getShape(from: getPoints(path: path3), for: self, totalPoints: 100)
        expectedPathView.alpha = 0.5
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
        context.setStrokeColor(UIColor.red.cgColor)
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
