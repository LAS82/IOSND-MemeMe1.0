//
//  MemeDetailViewController.swift
//  IOSND-MemeMe1.0
//
//  Created by Leandro Alves Santos on 13/05/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var meme: Meme! = nil
    
    @IBOutlet weak var imagem: UIImageView!
    
    override func viewDidLoad() {
        imagem.image = meme.memedImage
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
