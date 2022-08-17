//
//  LettersViewController.swift
//  Drawing
//
//  Created by Mohamd Bitar on 7/25/22.
//

import UIKit

final class LettersViewController: UIViewController {
    @IBOutlet weak var traceView: TraceView!
    @IBOutlet weak var placeholderImage: UIImageView!
    
    let imageView: UIImageView = {
        let arrowImage = UIImage(named: "arrow")
        let imageView = UIImageView(image: arrowImage)
        return imageView
    }()
    
    var workingPathIndex: Int = 0
    var paths: [Path] = []
    var letter: Letter!
    var points: [CGPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderImage.image = UIImage(named: letter.image)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateUI(letter: letter)
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
    
    private func updateUI(letter: Letter) {
        
        traceView.addSubview(imageView)
        
        placeholderImage.image = UIImage(named: letter.image)
        letter.paths.enumerated().forEach { (index, currentPath) in
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
    
    @IBAction func autoplayBtnTapped(_ sender: UIButton) {
        imageView.isHidden = true
        traceView.autoPlayShape()
    }
    
    @IBAction func resetBtnTapped(_ sender: UIButton) {
//        imageView.isHidden = false
    }
}
