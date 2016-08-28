//
//  BaseHeaderFooterView.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import UIKit

class BaseHeaderFooterView: UITableViewHeaderFooterView {

    var sectionNo : Int?
    var delegate : HeaderCommunicator?
    
    // MARK: Actions
    
    func didTapOnHeaderCell(tapGesture : UITapGestureRecognizer) {
        self.delegate?.didClickOnHeaderCell(self)
    }

}
