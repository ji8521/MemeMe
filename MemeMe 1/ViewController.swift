//
//  ViewController.swift
//  MemeMe 1
//
//  Created by Jeffrey Isaray on 11/17/15.
//  Copyright © 2015 Jeffrey Isaray. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate {

   
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photosButton: UIBarButtonItem!
  
    
    var currentKeyboardHeight: CGFloat = 0.0
    
    let memeTextAttributes = [
        // Outline color
        NSStrokeColorAttributeName: UIColor.blackColor(),
        // Fill color
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        // Font name
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        // Outline width
        NSStrokeWidthAttributeName: -3
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.enabled = false
        memeTextFieldAttributes(topTextField)
        memeTextFieldAttributes(bottomTextField)

    }
    
    func memeTextFieldAttributes(textfield: UITextField) {
        
        topTextField.backgroundColor = UIColor.clearColor()
        bottomTextField.backgroundColor = UIColor.clearColor()
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromPhotos(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true) {
            self.shareButton.enabled = true
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = {
            activity, success, items, error in
            if success {
                self.saveMeme()
            }
        }
    }
    
    @IBAction func cancelShare(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveMeme() {
        // Create meme
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide navigation bar and toolbar
        hide(true, animated: false)
        
        //Generate Meme
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show navigation bar and toolbar
        hide(false, animated: false)
        
        return memedImage
    }
    
    func hide(flag: Bool, animated: Bool) {
        navigationController?.setNavigationBarHidden(flag, animated: animated)
        navigationController?.setToolbarHidden(flag, animated: animated)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Clear text field when user taps
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || bottomTextField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // Dismiss keyboard when user presses enter
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Dismiss image picker if user presses cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            let kbSize: CGFloat = getKeyboardHeight(notification)
            let deltaHeight: CGFloat = kbSize - currentKeyboardHeight
            view.frame.origin.y -= deltaHeight
            currentKeyboardHeight = kbSize
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        currentKeyboardHeight = 0
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //of CGRect
        return keyboardSize.CGRectValue().height

    }
}
