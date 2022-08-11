//
//  CustomViewController.swift
//  Drawing
//
//  Created by Mohamd Bitar on 8/11/22.
//

import UIKit

final class CustomViewController: UIViewController {

    @IBOutlet weak var manView: ManView!
    
    var number: Int = 0 {
        didSet {
            DispatchQueue.main.async { [self] in
                manView.number = number
            }
        }
    }
    
    @IBAction func increaseBtnTapped(_ sender: UIButton) {
        number += 1
    }
}
