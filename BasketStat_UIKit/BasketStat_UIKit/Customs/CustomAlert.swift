//
//  CustomAlert.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 9/17/24.
//

import Foundation
import UIKit

final class CustomAlert {
    static let shared = CustomAlert()

    func showAutoDismissAlert(on viewController: UIViewController, title: String, message: String, duration: Double) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // ViewController에 알림창 표시
        viewController.present(alert, animated: true, completion: nil)
        
        // duration 이후에 알림창 자동으로 닫기
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
