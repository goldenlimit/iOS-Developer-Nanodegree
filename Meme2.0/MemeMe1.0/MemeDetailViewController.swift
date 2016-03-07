//
//  MemeDetailViewController.swift
//  MemeMe2.0
//
//  Created by goldenlimit on 2/8/16.
//  Copyright © 2016 Yue Wu. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme?
    var memeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deleteButton = UIBarButtonItem(title: "Delete", style: .Plain, target: self, action: "clickedDeleteButton")
        let editButton = UIBarButtonItem(title:"Edit", style: .Plain, target: self, action: "clickedEditButton")
        
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme?.memedImage
    }
    
    func clickedEditButton() {
        performSegueWithIdentifier("EditMeme", sender: self)
    }
    
    func clickedDeleteButton() {
        if let index = memeIndex {
            MemesStorage.defaultStorage.deleteMemeAtIndex(index)
        }
        navigationController?.popToRootViewControllerAnimated(true)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let editController = segue.destinationViewController as? MemeEditorViewController {
            editController.editingMeme = meme
        }
    }
}
