//
//  AppInfoCollectionViewCell.swift
//  AppleExplore
//
//  Created by kuliza-195 on 28/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import UIKit

class AppInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 25.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
 
}
