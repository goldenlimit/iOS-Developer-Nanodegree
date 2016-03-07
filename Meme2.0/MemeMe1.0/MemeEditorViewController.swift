//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Yue Wu on 12/9/15.
//  Copyright © 2015 Yue Wu. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var saveImage: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var keyboardManager: KeyboardManager?
    var editingMeme: Meme?
    var memedImage: UIImage!
    var selectedTextField: UITextField!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        topTextField.hidden = false
        bottomTextField.hidden = false
        
        //Set the delegates for textField
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0,
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        setupEditingMeme()
    }
    
    func setupEditingMeme() {
        if let meme = editingMeme {
            imagePickerView.image = meme.memedImage
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    @IBAction func clickedShareButton(sender: UIBarButtonItem) {

        presentActivityViewController()
    }

    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        imagePickerView.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePickerView, animated: true, completion: nil)
        cancelButton.enabled = true
    }

    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        imagePickerView.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePickerView, animated: true, completion: { () -> Void in
            self.saveImage.enabled = true
            self.cancelButton.enabled = true
            }
        )
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info [UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            //Set Content Mode for ImagPickerView
            imagePickerView.contentMode = .ScaleAspectFill
            
            dismissViewControllerAnimated(true, completion: { () -> Void in
               self.saveImage.enabled = true
            })
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
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
            view.frame.origin.y = 0
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
    
    ///Save the meme image:
    func save() -> UIImage {
        //Create the meme
        
        let memedImage = MemeGenerator.generateImageFromView(view)
        
        let meme  = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
        MemesStorage.defaultStorage.saveMeme(meme)
        
        return memedImage
    }
    
    
    func presentActivityViewController() {
        let image = save()
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.completionWithItemsHandler = {actiivityType, completed, items, error in self.dismissViewControllerAnimated(true, completion: nil)}
        presentViewController(activityController, animated: true, completion: nil)
    }

    
    func generateMemedImage() -> UIImage {
        //Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
}

