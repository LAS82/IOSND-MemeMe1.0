//
//  CollectionViewController.swift
//  IOSND-MemeMe1.0
//
//  Created by Leandro Alves Santos on 12/05/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    //MARK: - App data
    
    let memes = (UIApplication.shared.delegate as! AppDelegate).memes
    
    //MARK: - View events
    
    //Sets tabBar visibility
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Collection Methods
    
    //Sets the collections length
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    //Sets a view's row
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCell
        let meme = self.memes[indexPath.row]
        
        cell.image?.image = meme.memedImage
        
        return cell
    }
    
    //Show image's detail
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetail") as! MemeDetailViewController
        
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}
