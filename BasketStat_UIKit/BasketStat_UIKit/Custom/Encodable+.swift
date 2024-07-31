//
//  Dictionary+.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/31/24.
//

import Foundation
extension Encodable {
    
    var toDictionary : [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}
