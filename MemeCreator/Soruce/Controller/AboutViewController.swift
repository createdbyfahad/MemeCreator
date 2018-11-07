//
//  AboutViewController.swift
//  MemeCreator
//
//  Created by Fahad Alarefi on 8/3/18.
//  Copyright © 2018 createdbyFahad. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var textViewTop: UITextView!
    @IBOutlet weak var textViewBottom: UITextView!
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustUITextViewHeight(arg: textViewTop)
        adjustUITextViewHeight(arg: textViewBottom)
    }
}
