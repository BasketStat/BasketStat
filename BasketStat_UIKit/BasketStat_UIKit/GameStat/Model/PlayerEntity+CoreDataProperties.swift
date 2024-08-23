//
//  PlayerEntity+CoreDataProperties.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 8/21/24.
//
//

import Foundation
import CoreData


extension PlayerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerEntity> {
        return NSFetchRequest<PlayerEntity>(entityName: "PlayerEntity")
    }
    
    @NSManaged public var player: UUID?
    @NSManaged public var team: String
    @NSManaged public var two_pa: Int16
    @NSManaged public var two_pm: Int16
    @NSManaged public var three_pa: Int16
    @NSManaged public var three_pm: Int16
    @NSManaged public var ft_pa: Int16
    @NSManaged public var ft_pm: Int16
    @NSManaged public var ast: Int16
    @NSManaged public var reb: Int16
    @NSManaged public var stl: Int16
    @NSManaged public var blk: Int16
    @NSManaged public var foul: Int16
    @NSManaged public var point: Int16
    @NSManaged public var turnover: Int16
    @NSManaged public var number: Int16


}
