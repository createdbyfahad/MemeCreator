//
//  MemeBackgroundCell.swift
//  MemeCreator
//
//  Created by Fahad Alarefi on 8/14/18.
//  Copyright © 2018 createdbyFahad. All rights reserved.
//

import UIKit


class MemeBackgroundCell: UICollectionViewCell{
    // MARK: Properties
    @IBOutlet private weak var memeBackgroundCell: UIImageView!
    
    // MARK: Conf
    func update(withImageName imageName: String) {
        memeBackgroundCell.image = UIImage(named: imageName)
    }
}
