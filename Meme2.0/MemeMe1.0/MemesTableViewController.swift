//
//  MemesTableViewController.swift
//  MemeMe2.0
//
//  Created by goldenlimit on 1/16/16.
//  Copyright © 2016 Yue Wu. All rights reserved.
//

import UIKit

class MemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sent Memes"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let detailController = segue.destinationViewController as? MemeDetailViewController {
            detailController.meme = MemesStorage.defaultStorage.memeAtIndex(selectedIndex)
            detailController.memeIndex = selectedIndex
        }
    }
    
    @IBAction func clickedEditButton(sender: UIBarButtonItem) {
        
        tableView.editing = !tableView.editing
        sender.title = tableView.editing ? "Done" : "Edit"
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MemesStorage.defaultStorage.numberOfMemes()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! SendMemesTableViewCell
        let meme = MemesStorage.defaultStorage.memeAtIndex(indexPath.row)
        cell.memeImageView.image = meme?.memedImage
        cell.memeTitle.text = meme?.topText
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndex = indexPath.row
        performSegueWithIdentifier("MemeDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            MemesStorage.defaultStorage.deleteMemeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    
}

