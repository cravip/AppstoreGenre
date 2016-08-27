
//
//  PopAnimationhandler.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import Foundation
import UIKit

class PopAnimationHandler : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.0
    }
    
    // handles merging of cells when parent category is tapped
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
    }
}