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
    var delete: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = selectedMeme.memedImage {
            imageView.image = image
            delete = UIBarButtonItem(title: "Delete", style: .Done, target: self, action: "deleteMeme")
            
             self.navigationItem.rightBarButtonItems = [delete]
        }
    }
    
    func deleteMeme() {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        applicationDelegate.memes.removeLast()
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
