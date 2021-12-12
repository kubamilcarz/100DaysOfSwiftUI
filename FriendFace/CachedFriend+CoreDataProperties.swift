//
//  CachedFriend+CoreDataProperties.swift
//  FriendFace
//
//  Created by Kuba Milcarz on 10/12/2021.
//
//

import Foundation
import CoreData


extension CachedFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var user: CachedUser?

    // wrapped properties
    public var wrappedName: String {
        name ?? "Unknown name"
    }
}

extension CachedFriend : Identifiable {

}
