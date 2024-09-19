//
//  CustomUserDefault.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 9/13/24.
//

import Foundation



class CustomUserDefault {
    
    static let shared = CustomUserDefault()
    
    func resetAll() {
        UserDefaults.standard.set([], forKey: "picked")
        UserDefaults.standard.set([], forKey: "homePickedNums")
        UserDefaults.standard.set([], forKey: "awayPickedNums")
        
    }
    
    func changePicked(bef:String, aft:String) {
        guard let picked: [String] = UserDefaults.standard.stringArray(forKey: "picked") else {return}
        var aftPicked = picked.filter { !$0.contains(bef) }
        aftPicked.append(aft)
        UserDefaults.standard.set(aftPicked, forKey: "picked")
        
    }
    func delPicked(uid: String, num: String , isHome: Bool) {
        
        let result = isHome ? "homePickedNums" : "awayPickedNums"

        guard let picked: [String] = UserDefaults.standard.stringArray(forKey: "picked") else {return}

        let aftPicked = picked.filter { $0 == uid }
        UserDefaults.standard.set(aftPicked, forKey: "picked")
        
        guard let pickedNums: [String] = UserDefaults.standard.stringArray(forKey: result) else {return}

        let aftPickedNums = pickedNums.filter { $0 != num }
        UserDefaults.standard.set(aftPickedNums, forKey: result)

        

    }
    
    func pushPicked(uid: String) {
        guard var picked: [String] = UserDefaults.standard.stringArray(forKey: "picked") else {return}
        picked.append(uid)
        UserDefaults.standard.set(picked, forKey: "picked")
        
    } 
    
    func pushArr(uids: [String]) {
        
        UserDefaults.standard.set(uids, forKey: "picked")
        
    }
    
    func setPickNum(nums: [String], isHome: Bool) {
        let result = isHome ? "homePickedNums" : "awayPickedNums"

        if var homePickedNums = UserDefaults.standard.stringArray(forKey: result) {
            for num in nums {
                homePickedNums.append(num)
            }
            UserDefaults.standard.set(homePickedNums, forKey: result)

        }
        UserDefaults.standard.set(nums, forKey: result)
    }
    
  
    func determinePick(num: String, isHome: Bool) -> Bool {
        let result = isHome ? "homePickedNums" : "awayPickedNums"

        
        if let homePickedNums = UserDefaults.standard.stringArray(forKey: result) {
            print("homePickednums \(homePickedNums) num \(num) result \(result) \(!homePickedNums.contains(num)) contains")
            return !homePickedNums.contains(num)
            
        }
        else {
            return true
        }
    }
    
    
    
}
