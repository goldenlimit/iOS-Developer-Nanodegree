//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Yue Wu on 12/9/15.
//  Copyright © 2015 Yue Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var saveImage: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    var memedImage: UIImage!
    var selectedTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        topTextField.hidden = false
        bottomTextField.hidden = false
        
        //Set Content Mode for ImagPickerView
        imagePickerView.contentMode = .ScaleAspectFill
        
        //Set the delegates for textField
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
    }
    
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        let imageToShare = generateMemedImage()
        let activityItems = [imageToShare]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: {self.save()})
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        imagePickerView.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerView, animated: true, completion: nil)
    }

    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        imagePickerView.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePickerView, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info [UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //set condition that only execute this when bottom text field keyboard popup
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
            print("\(notification.name): \(notification.userInfo ?? [:])")
        }
        
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        print("\(notification.name): \(notification.userInfo ?? [:])")
        if bottomTextField.editing {
        return keyboardSize.CGRectValue().height
        } else {
            return 0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder(){
            view.frame.origin.y += getKeyboardHeight(notification)
            print("\(notification.name): \(notification.userInfo ?? [:])")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Save the meme image:
    func save() {
        //Create the meme
        let meme  = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
        print("\(topTextField) ?? \(bottomTextField) ?? \(imagePickerView) ?? \(memedImage)")
        print(meme.bottomText)
    }
    
    func generateMemedImage() -> UIImage {
        //TODO: Hide toolbar and navbar
        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
}

