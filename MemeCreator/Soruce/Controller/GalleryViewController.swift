//
//  FirstViewController.swift
//  MemeCreator
//
//  Created by Fahad Alarefi on 8/3/18.
//  Copyright © 2018 createdbyFahad. All rights reserved.
//

import UIKit
import CoreData

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: Properties
    private var fetchedResultsController: NSFetchedResultsController<Meme>?
    var selectedCategory: Category?
    private var selectedImageInfo: Meme?
    
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let someCategory = selectedCategory, let resultsController = try? GalleryService.shared.fetchedResultsControllerForMemes(in: someCategory) {
            navigationItem.title = someCategory.name
            resultsController.delegate = self
            fetchedResultsController = resultsController
        } else {
            fetchedResultsController = nil
        }
        
        memeCollectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("meme count: ", String(fetchedResultsController?.sections?[section].numberOfObjects ?? 0))
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeImageCell", for: indexPath) as! MemeImageCell
        let meme = fetchedResultsController!.object(at: indexPath)
        if let memeImage = meme.meme?.image{
//            let image = UIImage(data: memeImage)
            cell.update(withImage: UIImage(data: memeImage)!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // send user to the single image view scene to the meme
        let meme = fetchedResultsController!.object(at: indexPath)
        selectedImageInfo = meme
        
        performSegue(withIdentifier: "ShowSingleMemeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSingleMemeSegue" {
//            let navigationController = segue.destination as! UINavigationController
            let destinationVC = segue.destination as! SingleMemeViewController
            if let created_at = selectedImageInfo?.created_at{
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                destinationVC.title = dateFormatter.string(from: created_at)
            }
            
            destinationVC.selectedMeme = selectedImageInfo
            
        }
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            memeCollectionView.deleteItems(at: [indexPath!])
        case .insert:
            memeCollectionView.insertItems(at: [newIndexPath!])
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            memeCollectionView.deleteSections(IndexSet(integer: sectionIndex))
        case .insert:
            memeCollectionView.insertSections(IndexSet(integer: sectionIndex))
        default:
            print("Unexpected change type in controller:didChangeSection:atIndex:forChangeType:")
        }
    }
    


    


}

