//
//  MemeImageCell.swift
//  MemeCreator
//
//  Created by Fahad Alarefi on 8/4/18.
//  Copyright © 2018 createdbyFahad. All rights reserved.
//

import UIKit


class MemeImageCell: UICollectionViewCell{
    // MARK: Properties
    @IBOutlet private weak var memeImageCell: UIImageView!
    
    // MARK: Conf
    func update(withImage image: UIImage){
        memeImageCell.image = image
    }
}
