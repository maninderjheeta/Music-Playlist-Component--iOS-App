//
//  SongTableViewController.swift
//  MusicPlayList
//
//  Created by Maninder Singh Jheeta on 7/13/17.
//  Copyright © 2017 Maninder Singh Jheeta. All rights reserved.
//

import UIKit
import CoreData

class SongTableViewController: UIViewController,NSFetchedResultsControllerDelegate {
    
    var playVC : PlayListTableViewController!
    var playList : PlayList!
    var songPredicate: NSPredicate?
    var container: NSPersistentContainer!
    var songFetchedResultsController: NSFetchedResultsController<Song>!
    var songsInPlayList: [String : String] = [:]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting table view delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        container = playVC.container
        //set the title of the navigation bar -> already set
        
        //load all the Songs for the given PlayList
        loadSongsFromDatabase()
    }
    
    @IBAction func addSong(_ sender: UIButton) {
        //add the songs from the List of Songs available.
        //need to show a screen from where user can select 
        //songs

        if let musicVC = storyboard?.instantiateViewController(withIdentifier: "music") as? MusicViewController {
            musicVC.songVC = self
            navigationController?.pushViewController(musicVC, animated: true)
        }
    }
    
    func saveSongToDatabase(name : String) {
        // saving Song to database
        let song = Song(context: playVC.container.viewContext)
        song.name = name
        song.ofPlayList = playList
        print("\(String(describing: song.name)) -- \(String(describing: song.ofPlayList))")
        playVC.saveContext()
        //set predicate
        loadSongsFromDatabase()
    }
    
    func loadSongsFromDatabase() {
        print(playList.name)
        songPredicate = NSPredicate(format: "ofPlayList == %@", playList)
        songLoadSavedData()
    }

    
    func songLoadSavedData() {
        let request = Song.createFetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
        
        songFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        songFetchedResultsController.delegate = self
        
        songFetchedResultsController.fetchRequest.predicate = songPredicate
        
        do {
            try songFetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
}

extension SongTableViewController : UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(songFetchedResultsController.sections?[section])
        if let sectionInfo = songFetchedResultsController.sections?[section] {
            print("correct\(sectionInfo.numberOfObjects)")
            return sectionInfo.numberOfObjects
        }
        print("can only reach here")
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "song", for: indexPath)
        
        let song = songFetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = song.name
        songsInPlayList[song.name!] = song.name!
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //deleting song from the playList
        if editingStyle == .delete {
            let commit = songFetchedResultsController.object(at: indexPath)
            container.viewContext.delete(commit)
            tableView.deleteRows(at: [indexPath], with: .fade)
            playVC.saveContext()
        }
    }
}
