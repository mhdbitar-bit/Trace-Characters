//
//  ProgressTrackerView.swift
//  Drawing
//
//  Created by Mohamd Bitar on 7/29/22.
//

import UIKit

class ProgressTrackerView: UIView {
    
    
    // Array for holding circular bezier paths
    var paths = [UIBezierPath()]
    
    
    // Number of circles to make, this will be later determined
    // by some automatic measn based on some server logic... for simplicity sake, this will
    // not go above 4.
    var numberOfElements = 4
    
    
    // Stores stride points... see calculateStridePoints() method.
    // In a nutshell, stride points are used to draw circular bezier paths
    // inside the rectangular path.
    var stridePoints = [CGPoint()]
    
    
    // The bezier path that will be drawn into, possibly, maybe a CGRect?
    var progressTrackerRect: UIBezierPath = UIBezierPath()
    
    
    /** Computes and returns the `bounds.width` value of the `ProgressTrackerView`. */
    var progressTrackerViewWidth: CGFloat {
        
        return bounds.width
        
    }
    
    
    
    /** Computes and returns the `bounds.height` value of the `ProgressTrackerView`. */
    var progressTrackerViewHeight: CGFloat {
        
        return bounds.height
        
    }
    
    
    
    // Size Ratios
    // These were determined by doing some quick mockups in Keynote
    private struct SizeRatios {
        
        
        /** Ratio to set the width of the `progressTrackerRect` to be proportional to the width of the `ProgressTrackerView` */
        static let progressTrackerRectWidthToViewWidth: CGFloat = 0.885
        
        
        /** Ratio to set the height of a progress element proportional to height of the `ProgressTrackerView` */
        static let progressElementHeightToViewHeight: CGFloat = 0.531
        
        
        /** Ratio to set the height of a line proportional to the height of a progress element */
        static let lineHeightToProgressElementHeight: CGFloat = 0.250
        
        
    }
    
    
    
    
    
    /** Configures and returns a rectangular bezier path. The progress tracker (composes of circular elements and lines) will be drawn in the bounds
     of this bezier path.*/
    func prepareRectForProgressTracker() -> UIBezierPath {
        
        
        /** Define the width and height of the progress tracker rectangle. */
        let progressTrackerRectWidth = progressTrackerViewWidth * SizeRatios.progressTrackerRectWidthToViewWidth
        let progressTrackerRectHeight = progressTrackerViewHeight * SizeRatios.progressElementHeightToViewHeight
        
        
        /** Define the x and y coordinates of the rectangle */
        let xRect = (progressTrackerViewWidth - progressTrackerRectWidth) / 2
        let yRect = (progressTrackerViewHeight - progressTrackerRectHeight) / 2
        
        
        /** The final rectangle to be returned */
        let progressTrackerRectPath = UIBezierPath(rect: CGRect(x: xRect, y: yRect, width: progressTrackerRectWidth, height: progressTrackerRectHeight))
        
        progressTrackerRectPath.lineWidth = 2.0
        
        
        progressTrackerRect = progressTrackerRectPath
        
        return progressTrackerRect
        
        
        
    }
    
    
    
    
    func calculateStridePoints() {
        
        let subtractedValue = progressTrackerRect.bounds.width / CGFloat(numberOfElements * 2)
        
        let strideByConstant = progressTrackerRect.bounds.width / CGFloat(numberOfElements)
        
        for strideValue in stride(from: strideByConstant, to: progressTrackerRect.bounds.width + strideByConstant, by: strideByConstant) {
            
            let stridePoint = CGPoint(x: strideValue - subtractedValue, y: progressTrackerRect.bounds.midY)
            
            stridePoints.append(stridePoint)
            
            
            
            print(stridePoint)
            
        }
        
    }
    
    
    
    
    // This is where I am stuck... trying to draw only one path for now for testing purposes...
    // but how to i make sure that the arc center point is a poin in the rectangular bezier path and not the view...
    func makeElementAt() -> UIBezierPath {
        
        
        
        
        let circlePath = UIBezierPath(arcCenter: stridePoints[0],
                                      radius: (progressTrackerRect.bounds.height / 2),
                                      startAngle: 0.0,
                                      endAngle: CGFloat(2*Double.pi),
                                      clockwise: false)
        
        
        
        return circlePath
        
        
    }
    
    
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        
        
        
        let color = UIColor.red
        color.setStroke()
        
        let progressTrackerRect = prepareRectForProgressTracker()
        progressTrackerRect.stroke()
        
        
        
        
        
        /// I know bad coding practice, drawRect is only for drawing, I'm just
        /// doing this to get the fundamentals working and will move this outta
        /// drawRect..
        calculateStridePoints()
        
        let circlePathColor = UIColor.blue
        circlePathColor.setStroke()
        circlePathColor.setFill()
        
        let testCirclePath = makeElementAt()
        testCirclePath.stroke()
        testCirclePath.fill()
        
        
    }
}
