//
//  PlayListPopUpViewController.swift
//  MusicPlayList
//
//  Created by Maninder Singh Jheeta on 7/9/17.
//  Copyright © 2017 Maninder Singh Jheeta. All rights reserved.
//

import UIKit

class PlayListPopUpViewController: UIViewController {
    
    //text field for playList Name
    @IBOutlet weak var playListName: UITextField!
    
    var playVC : PlayListTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playListName.becomeFirstResponder()
    }
    
    //dismisses the pop if clicked outside
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //cancel button
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePlayList(_ sender: UIButton) {
         //Create new playList
        let text = playListName.text
        //Validation for empty name
        if text == "" {
            let alert = UIAlertController(title: "Name Required", message: "Cannot save an empty name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            playVC.savePlayListsToDatabase(name: text!)
            playVC.tableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
    }
    
}
