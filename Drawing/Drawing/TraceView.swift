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
    private var maxDistance: CGFloat = 20
    private var shouldStartTracing: Bool = false
    
    // Change it depends on character
    var lineWidth: CGFloat = 17.5
    
    var lastPathIndex: Int = 0
    var lastPointIndex: Int = 0
    
    var startPath: ((Bool) -> Void)?
    var isStartingNewPath: Bool = false {
        didSet {
            startPath?(isStartingNewPath)
        }
    }
    
    private var pendingPaths = [Path]()
    private var isComplete: Bool {
        return pendingPaths.isEmpty
    }
    
    var expectedPaths: [Path] {
        get { return _expectedPaths }
        set {
            _expectedPaths = newValue.map {
                return Path(points: $0.points)
            }
            pendingPaths = _expectedPaths
            drawExpectedPaths(paths: newValue)
        }
    }
    
    required init?(coder: NSCoder) {
        expectedPathView = UIImageView(coder: coder)
        
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        expectedPathView = UIImageView(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(expectedPathView)
        
        self.expectedPathView.alpha = 0.5
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.isEmpty {
            return
        }
        if let touch = touches.first {
            let end = touch.location(in: self)

            if lastPathIndex < pendingPaths.count {
                let path = pendingPaths[lastPathIndex]
                let points = path.points

                if lastPointIndex < points.count {
                    let range = lastPointIndex + 20
                    var index = lastPointIndex
                    var dirty = false
                    var minIndexToDraw = lastPointIndex
                    while index < range && index < points.count {
                        let firstPoint = points[index]
                        let distance = getDistance(start: end, end: firstPoint)
                        if distance < maxDistance {
                            maxDistance = distance
                            dirty = true
                            minIndexToDraw = index
                        }
                        index += 1
                    }
                    
                    maxDistance = 20
                    
                    if !dirty {
                        return
                    }
                    
                    if lastPointIndex == 0 {
                        isStartingNewPath = false
                    }

                    while lastPointIndex < minIndexToDraw && lastPointIndex < points.count-1 {
                        let line = Line(start: points[lastPointIndex], end: points[lastPointIndex+1], outOfBounds: false)
                        self.lines.append(line)
                        lastPointIndex += 1

                    }
                }
            } else {
                pendingPaths.removeAll()
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.isEmpty {
            return
        }
        if let touch = touches.first {
            let end = touch.location(in: self)

            if lastPathIndex < pendingPaths.count {
                let path = pendingPaths[lastPathIndex]
                let points = path.points

                if lastPointIndex < points.count {
                    let range = lastPointIndex + 20
                    var index = lastPointIndex
                    var dirty = false
                    var minIndexToDraw = lastPointIndex
                    while index < range && index < points.count {
                        let firstPoint = points[index]
                        let distance = getDistance(start: end, end: firstPoint)
                        if distance < maxDistance {
                            maxDistance = distance
                            dirty = true
                            minIndexToDraw = index
                        }
                        index += 1
                    }
                    
                    maxDistance = 20
                    
                    if !dirty {
                        return
                    }

                    while lastPointIndex < minIndexToDraw && lastPointIndex < points.count-1 {
                        let line = Line(start: points[lastPointIndex], end: points[lastPointIndex+1], outOfBounds: false)
                        self.lines.append(line)
                        lastPointIndex += 1

                    }
                }
            } else {
                pendingPaths.removeAll()
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if lastPathIndex < pendingPaths.count {
            if lastPointIndex >= pendingPaths[lastPathIndex].points.count - 1 {
                lastPointIndex = 0
                lastPathIndex += 1
                
                if lastPathIndex == pendingPaths.count {
                    isStartingNewPath = false
                    pendingPaths.removeAll()
                    setNeedsDisplay()
                } else {
                    isStartingNewPath = true
                }
            }
        }
    }
    
    private func removePath(at index: Int) {
        if pendingPaths[index].points.count == 0 {
            pendingPaths.remove(at: index)
        }
    }
    
    private func isPointWithinBounds(_ point: CGPoint) -> Bool {
        return pendingPaths.contains { path in
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
        
        lines.forEach {
            drawLine(context: context, line: $0, overrideColor: overrideColor)
        }
        
//        UIGraphicsEndImageContext()
    }
    
    private func drawExpectedPaths(paths: [Path]) {
//        UIGraphicsBeginImageContext(expectedPathView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        paths.forEach {
            drawExpectedPath(context: context, path: $0)
        }
        
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        expectedPathView.image = image
    }
    
    private func drawExpectedPath(context: CGContext, path: Path) {
        let points = path.points
        
        guard var last = points.first else {
            return
        }
        
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.setStrokeColor(UIColor.clear.cgColor)
        points[1..<points.count].forEach { point in
            context.move(to: last)
            context.addLine(to: point)
            context.strokePath()
            last = point
        }
    }
    
    private func drawLine(context: CGContext, line: Line, overrideColor: CGColor?) {
        var color = UIColor(named: "lineColor")!.cgColor
        if line.outOfBounds {
            color = UIColor.red.cgColor
        } else if let overrideColor = overrideColor {
            color = overrideColor
        }
        
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.setStrokeColor(color)
        
        context.fillPath(using: .winding)
        
        context.move(to: line.start)
        context.addLine(to: line.end)
        context.strokePath()
    }
}

// MARK: - AutoPLay
extension TraceView {
    func autoPlayShape() {
        guard !pendingPaths.isEmpty else { return }
        let paths = pendingPaths.reversed()
        drawPath(paths: paths.compactMap { $0 }, index: paths.count-1)
    }
    
    func drawPath(paths: [Path], index: Int) {
        if index < 0 {
            return
        }
        animate(points: paths[index].points, index: 0) { [weak self] in
            self?.drawPath(paths: paths, index: index-1)
        }
    }
    
    func animate(points: [CGPoint], index: Int, completion: (() -> Void)?) {
        var i = index
        i = min(index + 1, points.count - 1)
        lines.append(Line(start: points[i], end: points[i-1], outOfBounds: false))
        setNeedsDisplay()
        
        if i < points.count-1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                self.animate(points: points, index: i, completion: completion)
            }
        } else {
            completion?()
        }
    }
}
