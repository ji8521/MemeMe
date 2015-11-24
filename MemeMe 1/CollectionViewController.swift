//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Jeffrey Isaray on 11/17/15.
//  Copyright © 2015 Jeffrey Isaray. All rights reserved.
//

import UIKit

private let reuseIdentifier = "sentMemeCell"

class CollectionViewController: UICollectionViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBAction func addButton(sender: AnyObject) {
        let editorViewController: EditorViewController = self.storyboard?.instantiateViewControllerWithIdentifier("editorViewController") as! EditorViewController
        presentViewController(editorViewController, animated: true, completion: nil)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let widthDimension = (self.view.frame.size.width - (2 * space)) / 4.0
        let heightDimension = (self.view.frame.size.width - (2 * space)) / 4.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(widthDimension, heightDimension)

    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        let meme = memes[indexPath.item]
        cell.sentMemeImage.image = meme.memedImage
    
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedMeme = memes[indexPath.item]
        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailViewController.selectedMeme = selectedMeme
    
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }

}
