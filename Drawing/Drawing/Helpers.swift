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

func getPoints(path: String) -> [VectorBody] {
    var points: [VectorBody] = []
    var vectorBody: VectorBody = VectorBody(points: [], type: .MOVE_TO)
    let trimmedStr = path.trimmingCharacters(in: .whitespacesAndNewlines)
    var pointsStr = ""
    for (index, char) in trimmedStr.enumerated() {
        switch char {
        case let c where c.lowercased() == "m":
            vectorBody.type = .MOVE_TO
            pointsStr = ""
            
        case let c where c.lowercased() == "l":
            vectorBody.points = pointsPathToObject(pointsString: pointsStr, vector: vectorBody)
            points.append(vectorBody)
            vectorBody.type = .LINE
            pointsStr = ""
            
        case let c where c.lowercased() == "q":
            vectorBody.points = pointsPathToObject(pointsString: pointsStr, vector: vectorBody)
            points.append(vectorBody)
            vectorBody.type = .QUAD
            pointsStr = ""
            
        case let c where c.lowercased() == "c":
            vectorBody.points = pointsPathToObject(pointsString: pointsStr, vector: vectorBody)
            points.append(vectorBody)
            vectorBody.type = .CUBIC
            pointsStr = ""
            
        case let c where c.lowercased() == "h":
            vectorBody.points = pointsPathToObject(pointsString: pointsStr, vector: vectorBody)
            points.append(vectorBody)
            vectorBody.type = .HORIZONTAL
            pointsStr = ""
            
        case let c where c.lowercased() == "v":
            vectorBody.points = pointsPathToObject(pointsString: pointsStr, vector: vectorBody)
            points.append(vectorBody)
            vectorBody.type = .VERTICAL
            pointsStr = ""
            
        case let c where c.lowercased() == "z":
            vectorBody.points = pointsPathToObject(pointsString: pointsStr, vector: vectorBody)
            points.append(vectorBody)
            vectorBody.type = .CLOSE
            pointsStr = ""
            
        default:
            pointsStr += char.description
            if index >= trimmedStr.count - 1 {
                vectorBody.points = pointsPathToObject(pointsString: pointsStr, vector: vectorBody)
                points.append(vectorBody)
            }
        }
    }
    
    return points
}

private func pointsPathToObject(pointsString: String, vector: VectorBody) -> [CGPoint] {
    var points = [CGPoint]()
    
    let type = vector.type
    let separators = CharacterSet(charactersIn: " ,")
    let subPoints = pointsString.components(separatedBy: separators)
    
    var x: CGFloat? = nil
    var y: CGFloat? = nil
    
    subPoints.enumerated().forEach { index, num in
        if !num.isEmpty {
            if type == .VERTICAL {
                y = CGFloat((num as NSString).floatValue)
                if let point = vector.points.last {
                    x = point.x
                }
                
                if let wrappedX = x, let wrappedY = y {
                    points.append(CGPoint(x: wrappedX, y: wrappedY))
                    x = nil
                    y = nil
                }
            } else if type == .HORIZONTAL {
                x = CGFloat((num as NSString).floatValue)
                if let point = vector.points.last {
                    y = point.y
                }
                
                if let wrappedX = x, let wrappedY = y {
                    points.append(CGPoint(x: wrappedX, y: wrappedY))
                    x = nil
                    y = nil
                }
            } else {
                if x == nil {
                    x =  CGFloat((num as NSString).floatValue)
                } else if y == nil {
                    y = CGFloat((num as NSString).floatValue)
                    
                    if let wrappedX = x, let wrappedY = y {
                        points.append(CGPoint(x: wrappedX, y: wrappedY))
                        x = nil
                        y = nil
                    }
                    
                    if index >= subPoints.count - 1 {
                        if let wrappedX = x, let wrappedY = y {
                            points.append(CGPoint(x: wrappedX, y: wrappedY))
                            x = nil
                            y = nil
                        }
                    }
                } else {
                    if let wrappedX = x, let wrappedY = y {
                        points.append(CGPoint(x: wrappedX, y: wrappedY))
                    }
                    y = nil
                    x = nil
                }
            }
            
            
            
            if let wrappedX = x, let wrappedY = y {
                points.append(CGPoint(x: wrappedX, y: wrappedY))
                x = nil
                y = nil
            }
        }
    }
    
    return points
}

func getPath(from vectors: [VectorBody], for view: UIView, totalPoints: Int) -> Path {
    var path = Path(points: [])
    var points: [CGPoint] = []
    let stroke1Path = UIBezierPath()
    
    vectors.forEach { vector in
        switch vector.type {
        case .MOVE_TO:
            if let point = vector.points.first {
                stroke1Path.move(to: point)
            }
        case .LINE:
            if let point = vector.points.first {
                stroke1Path.addLine(to: point)
            }
        case .QUAD:
            if !vector.points.isEmpty {
                stroke1Path.addQuadCurve(to: vector.points[1], controlPoint: vector.points[0])
            }
        case .CUBIC:
            if !vector.points.isEmpty {
                stroke1Path.addCurve(to: vector.points[2], controlPoint1: vector.points[0], controlPoint2: vector.points[1])
            }
        case .HORIZONTAL:
            if let point = vector.points.first {
                stroke1Path.addLine(to: point)
            }
        case .VERTICAL:
            if let point = vector.points.first {
                stroke1Path.addLine(to: point)
            }
        case .CLOSE:
            stroke1Path.close()
        }
    }
   
    for i in 0...totalPoints {
        let step: CGFloat = CGFloat(i) / CGFloat(totalPoints)
        if let point = stroke1Path.point(at: step) {
            let newPointRatioX = (point.x / 526) * 100
            let newPointRatioY = (point.y / 682) * 100
            
            let newPointX = (newPointRatioX * view.frame.width) / 100
            let newPointY = (newPointRatioY * view.frame.height) / 100
            let newPoint = CGPoint(x: newPointX, y: newPointY)
            points.append(newPoint)
        }
    }
    path = Path(points: points)
    points = []
    return path
}
