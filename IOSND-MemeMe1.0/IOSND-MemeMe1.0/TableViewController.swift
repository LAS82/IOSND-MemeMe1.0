//
//  TableViewController.swift
//  IOSND-MemeMe1.0
//
//  Created by Leandro Alves Santos on 12/05/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //MARK: - App data
    
    var memes = (UIApplication.shared.delegate as! AppDelegate).memes
    
    //MARK: - View events
    
    //Sets tabBar visibility
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Table methods
    
    //Sets the table's length
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    //Sets a view's row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        cell.imageView?.image = meme.memedImage
        cell.imageView?.isUserInteractionEnabled = true
        
        return cell
    }
    
    //Show image's detail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetail") as! MemeDetailViewController
        
        detailController.meme = self.memes[indexPath.row]
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
}
