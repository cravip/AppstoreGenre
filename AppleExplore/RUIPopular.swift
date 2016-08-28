//
//  RUIPopular.swift
//  AppleExplore
//
//  Created by kuliza-195 on 28/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import UIKit

class RUIPopular: UIView {

    
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var rootView : UIView!
    
    @IBAction func seeAllButtonClicked(sender: AnyObject) {
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.collectionView.registerNib(UINib.init(nibName: Constants.Cell.appInfoCellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.Cell.appInfoCellIdentifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpXib()
    }
 
  
    func setUpXib() {
        rootView = UINib(nibName: Constants.RUIViews.ruiPopular, bundle: nil).instantiateWithOwner(self, options: nil)[0] as! UIView
        rootView.frame = bounds
        rootView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]

        self.addSubview(rootView)
        
    }

}
