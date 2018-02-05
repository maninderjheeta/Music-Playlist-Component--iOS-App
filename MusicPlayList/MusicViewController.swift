//
//  MusicViewController.swift
//  MusicPlayList
//
//  Created by Maninder Singh Jheeta on 7/17/17.
//  Copyright © 2017 Maninder Singh Jheeta. All rights reserved.
//

import UIKit
import MediaPlayer
import MediaToolbox

class MusicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var songVC: SongTableViewController?
    
    var songs: [SongInfo] = []
    var songQuery: SongQuery = SongQuery()
    var audio: AVAudioPlayer?
    var checkedSongs: [String] = []
    
    @IBOutlet var tableView : UITableView?
    
    @IBAction func addToPlayList(_ sender: UIButton) {
        //save this songs to the playList
        for songName in checkedSongs {
           songVC?.saveSongToDatabase(name: songName)
        }
        //then dismiss the current MVC and move to the prev
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Songs"
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.songs = self.songQuery.get(songsInPlayList: (self.songVC?.songsInPlayList)!)
                DispatchQueue.main.async {
                    self.tableView?.rowHeight = UITableViewAutomaticDimension;
                    self.tableView?.estimatedRowHeight = 60.0;
                    self.tableView?.reloadData()
                }
            } else {
                self.displayMediaLibraryError()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isBeingDismissed || self.isMovingFromParentViewController {
                print("going out of view")
        }
    }
    
    func displayMediaLibraryError() {
        
        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "Media library access denied by user"
        default:
            error = "Unknown error"
        }
        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int  {
        return songs.count
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath:IndexPath ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "music",
            for: indexPath)
            cell.textLabel?.text = songs[indexPath.row].songTitle
            cell.detailTextLabel?.text = songs[indexPath.row].artistName
            cell.accessoryType = .none
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                if let index = checkedSongs.index(of: songs[indexPath.row].songTitle) {
                    checkedSongs.remove(at: index)
                }
                print("unchecked it")
            } else {
                cell.accessoryType = .checkmark
                checkedSongs.append(songs[indexPath.row].songTitle)
                print("checked it")
            }
        }
    }
}
