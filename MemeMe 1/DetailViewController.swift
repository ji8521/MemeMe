//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Jeffrey Isaray on 11/17/15.
//  Copyright © 2015 Jeffrey Isaray. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedMeme: Meme!
    var edit: UIBarButtonItem!
    var delete: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = selectedMeme.memedImage {
            imageView.image = image
            edit = UIBarButtonItem(title: "Edit", style: .Done, target: self, action: "editMeme")
            delete = UIBarButtonItem(title: "Delete", style: .Done, target: self, action: "deleteMeme")
            
            navigationItem.rightBarButtonItems = [edit, delete]
            imageView.image = selectedMeme.memedImage
            
        }
    }
    
    func deleteMeme() {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        applicationDelegate.memes.removeLast()
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func editMeme() {
        let editorViewController = storyboard!.instantiateViewControllerWithIdentifier("editorViewController") as! EditorViewController
        editorViewController.meme = selectedMeme
        presentViewController(editorViewController, animated: true, completion: nil)
    }
}
