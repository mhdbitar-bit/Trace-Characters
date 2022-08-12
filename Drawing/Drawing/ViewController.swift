//
//  ViewController.swift
//  Drawing
//
//  Created by Mohamd Bitar on 7/25/22.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak var traceView: TraceView!
    @IBOutlet weak var placeholderImage: UIImageView!
    
    let imageView: UIImageView = {
        let arrowImage = UIImage(named: "arrow")
        let imageView = UIImageView(image: arrowImage)
        return imageView
    }()
    
    var workingPathIndex: Int = 0
    var paths: [Path] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // Alef
//                let path1 = "M354 260C400 426.711 400 535.651 400 671"
        
        // Taa
        //        let path1 = "M570.5 322.5C578 336.167 592 368.3 588 387.5C537 437.5 462.5 456 385 457.5C307.5 459 180.001 436 223.5 334.5"
        //        let path2 = "M440 298.5C440 298.776 439.776 299 439.5 299C439.224 299 439 298.776 439 298.5C439 298.224 439.224 298 439.5 298C439.776 298 440 298.224 440 298.5Z"
        //        let path3 = "M360 298.5C360 298.776 359.776 299 359.5 299C359.224 299 359 298.776 359 298.5C359 298.224 359.224 298 359.5 298C359.776 298 360 298.224 360 298.5Z"
        
        // Baa
//        let path1 = "M570.5 322.5C578 336.167 592 368.3 588 387.5C537 437.5 462.5 456 385 457.5C307.5 459 180.001 436 223.5 334.5"
//        let path2 = "M398 541.5C398 541.776 397.776 542 397.5 542C397.224 542 397 541.776 397 541.5C397 541.224 397.224 541 397.5 541C397.776 541 398 541.224 398 541.5Z"
        
        //Ceen
//        let path1 = "M 596 338.5 C 648 459 543 466.5 535 381.5 C 543.047 467 448.5 468 448.5 400 C 448.5 495.493 420.5 556 331 574.545 C 241.5 593.09 159.329 556.649 215.5 431.5"
        
        //wow
//                let path1 = "M474.379 408C474.379 408 381.5 443 350.554 425C319.608 407 337.973 355.869 350.554 330.704C365.312 301.183 389.631 282.754 422.28 286.476C445.66 289.141 460.923 296.324 474.379 315.734C490.536 339.041 482.503 391.262 482.503 391.262"
//
//                let path2 = "M482.5 399C482.5 399 474.207 469.833 459.5 506.5C444.726 543.336 439.318 563.279 399.5 602.5C359.682 641.721 322 647 322 647"
        
        // Mem
        
//        let path1 = "M384.225 435.488C399.725 365.488 442.725 327.163 490.725 362.163C538.725 397.163 532.225 441.663 470.225 441.663C391.221 441.663 343.725 422.163 309.225 441.663C263.521 467.496 279.423 561 302.924 705.5"
        
        // Kaa
        
        let path1 = "M496.5 138.5C511 242.5 545.939 437.859 518 458C496.5 473.5 286.5 485.5 266 449.5C252.263 425.375 260 389 275.5 356.5"
        let path2 = "M420.461 232.138C347.299 241.859 349.122 314.045 434.454 334.902C367.86 348.647 356.955 350.717 345.122 352.545"
        
        // Laa
//        let path1 = "M477.548 240C487.458 368.967 487.51 474.575 477.548 530.426C462.391 615.405 203.551 623.403 290.997 421.954"
        
        // Zaa
//        let path1 = "M420.5 344C509.47 456.172 420.5 532 342 575.969"
//        let path2 = "M369 275.5C369 275.776 368.776 276 368.5 276C368.224 276 368 275.776 368 275.5C368 275.224 368.224 275 368.5 275C368.776 275 369 275.224 369 275.5Z"
        
        traceView.addSubview(imageView)
        
        
        [path1, path2].enumerated().forEach { (index, currentPath) in
            let path = getPath(from: getPoints(path: currentPath), for: traceView, totalPoints: 100)
            if path.points.count > 2 && index == 0 {
                addArrowImage(point1: path.points[0], point2: path.points[1])
            }
            paths.append(path)
            self.traceView.expectedPaths.append(path)
        }
        
        traceView.startPath = { [weak self] isHidden in
            guard let self = self else { return }
            if isHidden {
                self.workingPathIndex += 1
                let index = self.workingPathIndex
                if index < self.paths.count{
                    let path = self.paths[index]
                    if path.points.count > 2 {
                        self.addArrowImage(point1: path.points[0], point2: path.points[1])
                    }
                }
            }

            self.imageView.isHidden = !isHidden
        }
    }
    
    private func addArrowImage(point1: CGPoint, point2: CGPoint) {
        let arrowWidth: CGFloat = 25
        let arrowHeight: CGFloat = 25
        imageView.frame = CGRect(
            x: point1.x - (arrowWidth / 2),
            y: point1.y - (arrowHeight / 2),
            width: arrowWidth,
            height: arrowWidth
        )
        
        imageView.transform = CGAffineTransform.identity
        imageView.transform = imageView.transform.rotated(
            by: findAngle(
                point1: point1,
                point2: point2
            )
        )
    }
}
