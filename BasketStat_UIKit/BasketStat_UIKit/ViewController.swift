//
//  ViewController.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/9/24.
//

import UIKit
import Then
import SnapKit


class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [
            UIColor(red: 59/255, green: 43/255, blue: 92/255, alpha: 1).cgColor,    // #3B2B5C
            UIColor(red: 37/255, green: 33/255, blue: 90/255, alpha: 1).cgColor,    // #25215A
            UIColor.black.cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor
        ]
        
        gradientLayer.locations = [0.0, 0.2326, 0.7467, 0.8093, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.3044, y: 0.0363)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)

    }


}

extension UIView {
    func applyGradient(colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
