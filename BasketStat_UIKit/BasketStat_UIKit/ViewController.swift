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
            UIColor.fromRGB(59, 43, 92).cgColor,
            UIColor.fromRGB(37, 33, 90).cgColor,
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
