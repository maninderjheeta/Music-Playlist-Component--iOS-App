//
//  Song+CoreDataProperties.swift
//  MusicPlayList
//
//  Created by Maninder Singh Jheeta on 7/13/17.
//  Copyright © 2017 Maninder Singh Jheeta. All rights reserved.
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var name: String?
    @NSManaged public var ofPlayList: PlayList?

}
