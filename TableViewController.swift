//
//  TableViewController.swift
//  MemeMe
//
//  Created by Jeffrey Isaray on 11/17/15.
//  Copyright © 2015 Jeffrey Isaray. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

   
    @IBAction func addButton(sender: AnyObject) {
        let editorViewController: EditorViewController = self.storyboard?.instantiateViewControllerWithIdentifier("editorViewController") as! EditorViewController
        presentViewController(editorViewController, animated: true, completion: nil)
    }
    
    var memes: [Meme] {
       return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath: indexPath) as UITableViewCell!
        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText! + "-" + meme.bottomText!
        cell.detailTextLabel?.text = ""

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedMeme = memes[indexPath.row]
        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailViewController.selectedMeme = selectedMeme
        
        self.navigationController!.pushViewController(detailViewController, animated: true)
        
    }

}
