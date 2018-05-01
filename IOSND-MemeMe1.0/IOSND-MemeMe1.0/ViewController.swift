//
//  ViewController.swift
//  IOSND-MemeMe1.0
//
//  Created by Leandro Alves Santos on 30/04/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Outlet properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photosButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //MARK: - Other properties
    
    var memeData: Meme!
    var btnShare: UIBarButtonItem!
    
    //MARK: - View events
    
    //Initial config
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        enableOnlyAvailableSources()
        configTextFields()
        createShareButton()
    }
    
    //Starts listen the keyboard notifications
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    //Removes the keyboard notifications when the view disappear
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    //MARK: - Objects events
    
    //Configs the text field before the user start to type
    @IBAction func topTextDidBeginEdit(_ sender: Any) {
        
        unsubscribeToKeyboardNotifications()
        let topTextField = sender as! UITextField
        
        if topTextField.text == "TOP" {
            topTextField.text = String()
        }
    }
    
    //Configs the text field after the user ends typing
    @IBAction func topTextDidEndEdit(_ sender: Any) {
        
        subscribeToKeyboardNotifications()
        let topTextField = sender as! UITextField
        
        if topTextField.text == "" {
            topTextField.text = "TOP"
        }
    }
    
    //Configs the text field before the user start to type
    @IBAction func bottomTextDidBeginEdit(_ sender: Any) {
        
        let bottomTextField = sender as! UITextField
        var charSet = CharacterSet()
        charSet.insert(charactersIn: " ")
        
        
        if bottomTextField.text?.trimmingCharacters(in: charSet) == "BOTTOM" {
            bottomTextField.text = String()
        }
    }
    
    //Configs the text field after the user ends typing
    @IBAction func bottomTextDidEndEdit(_ sender: Any) {
        
        let bottomTextField = sender as! UITextField
        
        var charSet = CharacterSet()
        charSet.insert(charactersIn: " ")
        
        if bottomTextField.text?.trimmingCharacters(in: charSet) == "" {
            bottomTextField.text = "BOTTOM"
        }
    }
    
    //Opens the hardware camera
    @IBAction func cameraButton_click(_ sender: Any) {
        
        callImagePickerController(.camera)
    }
    
    //Opens the photo library
    @IBAction func photosButton_click(_ sender: Any) {
        
        callImagePickerController(.photoLibrary)
    }
    
    //Opens the view that share content
    @objc func btnShare_clicked() {
        
        let controller = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: - Keyboard control methods
    //Adds observers to KeyboardWillShow and KeyboardWillHide
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    //Removes the observers to KeyboardWillShow and KeyboardWillHide
    func unsubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //Resizes the view so the keyboard don't comes in his front
    @objc func keyboardWillShow(_ notification: Notification) {
        
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    //Resizes the view to cover all the safe area
    @objc func keyboardWillHide(_ notification: Notification) {
        
        view.frame.origin.y = 0
    }
    
    //Gets the keyboard size
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: - TextFields config methods
    
    //Gets the text attributes to use with defaultTextAttributes property of a TextField
    func getTextAttributes() -> [String:Any] {
        
        let memeTextAttributes : [String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -8
        ]
        
        return memeTextAttributes
    }
    
    //Configs the textFields
    func configTextFields() {
        
        let textAttributes = getTextAttributes()
        
        topTextField.defaultTextAttributes = textAttributes
        bottomTextField.defaultTextAttributes = textAttributes
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
        restartTextFields(true)
    }
    
    //Restart the TextFields to it's initial state, except for the visibility
    func restartTextFields(_ hidden: Bool) {
        
        topTextField.isHidden = hidden
        bottomTextField.isHidden = hidden
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        self.view!.bringSubview(toFront: topTextField)
        self.view!.bringSubview(toFront: bottomTextField)
    }
    
    
    //MARK: - Pick image methods
    
    //This method is called when the user selects an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = selectedImage
            enableShareButton(true)
        }
        
        picker.dismiss(animated: true, completion: {self.restartTextFields(false)})
    }

    //Calls the UIImagePickerController
    func callImagePickerController(_ sourceType: UIImagePickerControllerSourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: - Save and share image methods
    
    //Generates the memed image
    func generateMemedImage() -> UIImage {
        
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        
        saveMemeData(memedImage)
        
        return memedImage
    }
    
    //Saves the image information to the Meme structure
    func saveMemeData(_ memedImage: UIImage) {
        
        memeData = Meme(originalImage: imageView.image!, memedImage: memedImage, topText: topTextField.text!, bottomText: bottomTextField.text!)
    }
    
    //MARK: - Other methods
    
    //Enables only the buttons from the available sources
    func enableOnlyAvailableSources() {
        
        photosButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    //Creates the share button in the navigation bar
    func createShareButton() {
        
        btnShare = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(btnShare_clicked))
        
        enableShareButton(false)
        
        self.navigationItem.rightBarButtonItem = btnShare
    }
    
    //Enables or disables the share button
    func enableShareButton(_ enabled: Bool) {
        btnShare.isEnabled = enabled
    }
}

