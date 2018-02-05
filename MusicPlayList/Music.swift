//
//  Music.swift
//  MusicPlayList
//
//  Created by Maninder Singh Jheeta on 7/17/17.
//  Copyright © 2017 Maninder Singh Jheeta. All rights reserved.

//  Class for fetching the songs from the media library 
//  of the device.
//

import Foundation
import MediaPlayer

struct SongInfo {
    var albumTitle: String
    //will be using only this field
    //other fields can be used for extending 
    //the app later
    var artistName: String
    var songTitle:  String
    var songId   :  NSNumber
}

class SongQuery {
    func get(songsInPlayList: [String : String]) -> [SongInfo] {
        var songs: [SongInfo] = []
        let albumsQuery : MPMediaQuery = MPMediaQuery.albums()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
        for album in albumItems {
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            for song in albumItems {
                let songInfo: SongInfo = SongInfo(
                    albumTitle: song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String,
                    artistName: song.value( forProperty: MPMediaItemPropertyArtist ) as! String,
                    songTitle:  song.value( forProperty: MPMediaItemPropertyTitle ) as! String,
                    songId:     song.value( forProperty: MPMediaItemPropertyPersistentID ) as! NSNumber
                )
                if(!(songsInPlayList.values.contains(songInfo.songTitle))) {
                    songs.append(songInfo)
                }
            }
        }
        return songs
    }
}
