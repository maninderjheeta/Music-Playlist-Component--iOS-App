//
//  PlayListTableViewController.swift
//  MusicPlayList
//
//  Created by Maninder Singh Jheeta on 7/9/17.
//  Copyright © 2017 Maninder Singh Jheeta. All rights reserved.
//

import UIKit
import CoreData

class PlayListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //####################
    //core data 
    var container: NSPersistentContainer!
    var fetchedResultsController: NSFetchedResultsController<PlayList>!
    var playListPredicate: NSPredicate?

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = NSPersistentContainer(name: "MusicPlayList")
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        loadSavedData()
    }
    
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }

    
    func savePlayListsToDatabase(name : String) {
        // saving PlayList to database
        let playList = PlayList(context: self.container.viewContext)
        playList.name = name
        self.saveContext()
        self.loadSavedData()
    }
    func loadSavedData() {
        let request = PlayList.createFetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
            
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        
        fetchedResultsController.fetchRequest.predicate = playListPredicate
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    //####################
    var playListPass : PlayList?
    
    @IBAction func openPopUp(_ sender: UIButton) {
        //opening popUp for PlayList Name
        performSegue(withIdentifier: "popUp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popUp" {
            if let destination = segue.destination as? PlayListPopUpViewController {
                destination.playVC = self
            }
        }
//        } else if(segue.identifier == "playListDetail") {
//            if let destination = segue.destination as? SongTableViewController {
//                destination.playVC = self
//                print("value \(playListPass?.name)")
//                destination.title = playListPass?.name
//            }
        //add another segue here
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayList", for: indexPath)
        
        let playList = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = playList.name
        cell.detailTextLabel!.text = String(playList.songs?.count ?? 0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //action on select of a row from the table view cntroller
        //moving to PlayList detail Controller 
//        playListPass = fetchedResultsController.object(at: indexPath)
//        print("here /(playListPass)")
//        performSegue(withIdentifier: "playListDetail", sender: self)
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Song") as? SongTableViewController {
            vc.playList = fetchedResultsController.object(at: indexPath)
            vc.title = vc.playList.name
            vc.playVC = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

