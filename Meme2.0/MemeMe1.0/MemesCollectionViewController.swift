//
//  MemesCollectionViewController.swift
//  MemeMe2.0
//
//  Created by goldenlimit on 1/16/16.
//  Copyright © 2016 Yue Wu. All rights reserved.
//

import UIKit

class MemeCollectionViewContoller:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex: Int = 0
    var itemSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sent Memes"
        
        let width = view.bounds.size.width / 3
        itemSize = CGSizeMake(width, width)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailContorller = segue.destinationViewController as? MemeDetailViewController {
            detailContorller.meme = MemesStorage.defaultStorage.memeAtIndex(selectedIndex)
            detailContorller.memeIndex = selectedIndex
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemesStorage.defaultStorage.numberOfMemes()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell",forIndexPath: indexPath) as! SendMemeCollectionViewCell
        let meme = MemesStorage.defaultStorage.memeAtIndex(indexPath.item)
        cell.memeImageView.image = meme?.memedImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        performSegueWithIdentifier("MemeDetail", sender: self)
    }
}
