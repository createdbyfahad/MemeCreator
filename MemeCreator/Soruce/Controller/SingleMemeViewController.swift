//
//  SingleMemeViewController.swift
//  MemeCreator
//
//  Created by Fahad Alarefi on 8/14/18.
//  Copyright © 2018 createdbyFahad. All rights reserved.
//

import Foundation
import UIKit

class SingleMemeViewController: UIViewController{
    
    //MARK: Properties
    var selectedMeme: Meme?
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func shareMeme(_ sender: Any){
        // image to share
        guard let image = imageView.image else {
            return
        }
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo, UIActivityType.assignToContact, UIActivityType.print ]
        
        activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }
            
            let alertController = UIAlertController(title: "Succedded", message: "The meme has been saved/shared", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteMeme(_ sender: Any) {
        guard let meme = selectedMeme else {
            return
        }
        
        // delete the meme
        do{
            try GalleryService.shared.delete(meme)
            navigationController?.popViewController(animated: true)
        } catch {
            let alertController = UIAlertController(title: "Failed", message: "Failed to delete the meme", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        if let meme = selectedMeme?.meme?.image{
            imageView.image = UIImage(data: meme)
        }
    }
}
