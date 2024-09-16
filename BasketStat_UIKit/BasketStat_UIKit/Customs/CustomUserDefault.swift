//
//  CustomUserDefault.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 9/13/24.
//

import Foundation



class CustomUserDefault {
    
    static let shared = CustomUserDefault()
    
    func changePicked(bef:String, aft:String) {
        guard let picked: [String] = UserDefaults.standard.stringArray(forKey: "picked") else {return}
        var aftPicked = picked.filter { !$0.contains(bef) }
        aftPicked.append(aft)
        UserDefaults.standard.set(aftPicked, forKey: "picked")
        
    }
    func delPicked(uid: String) {
        guard let picked: [String] = UserDefaults.standard.stringArray(forKey: "picked") else {return}
        var aftPicked = picked.filter { !$0.contains(uid) }
        UserDefaults.standard.set(aftPicked, forKey: "picked")
        
    }
    
    func pushPicked(uid: String) {
        guard var picked: [String] = UserDefaults.standard.stringArray(forKey: "picked") else {return}
        picked.append(uid)
        UserDefaults.standard.set(picked, forKey: "picked")
        
    } 
    
    func pushArr(uids: [String]) {
        
        UserDefaults.standard.set(uids, forKey: "picked")
        
    }
    
    
    
}
