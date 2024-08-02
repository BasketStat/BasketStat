//
//  KeyBoard.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/31/24.
//

import Foundation
import UIKit


class KeyBoard {
    
    
    static let shared = KeyBoard()
    
    func KeyBoardSetting(vc: UIViewController){
        
        
        
        NotificationCenter.default.addObserver(vc, selector: #selector(vc.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(vc, selector: #selector(vc.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    func removeOb(vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(vc, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
}
