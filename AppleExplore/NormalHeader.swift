//
//  NormalHeader.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import UIKit

class NormalHeader: BaseHeaderFooterView {

    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BaseHeaderFooterView.didTapOnHeaderCell(_:)))
        self.arrowImageView.addGestureRecognizer(tapGesture)

    }
    
 
}
