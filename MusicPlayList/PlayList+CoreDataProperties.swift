//
//  PlayList+CoreDataProperties.swift
//  MusicPlayList
//
//  Created by Maninder Singh Jheeta on 7/13/17.
//  Copyright © 2017 Maninder Singh Jheeta. All rights reserved.
//

import Foundation
import CoreData


extension PlayList {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PlayList> {
        return NSFetchRequest<PlayList>(entityName: "PlayList")
    }

    @NSManaged public var name: String?
    @NSManaged public var songs: NSSet?

}

// MARK: Generated accessors for songs
extension PlayList {

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: Song)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: Song)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSSet)

}
