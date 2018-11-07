//
//  MemeBackgroundPickerViewController.swift
//  MemeCreator
//
//  Created by Fahad Alarefi on 8/14/18.
//  Copyright © 2018 createdbyFahad. All rights reserved.
//

import UIKit

class MemeBackgroundPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GalleryService.shared.memeBackgroundsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeBackgroundCell", for: indexPath) as! MemeBackgroundCell
        let imageName = GalleryService.shared.memeBackgroundName(atIndex: indexPath.row)
        cell.update(withImageName: imageName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // send the image to sender
        self.delegate?.userDidPickMemeBackground(GalleryService.shared.memeBackgroundName(atIndex: indexPath.row))
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellSize = (view.frame.width - 20) / 2
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: cellSize, height: cellSize)
    }
    
    // MARK: Properties (IBOutlet)
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: Properties
    weak var delegate: MemeBackgroundPickerControllerDelegate?
}
