//
//  PushAnimationHandler.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import Foundation
import UIKit

class PushAnimationHandler : NSObject, UIViewControllerAnimatedTransitioning {
    
     func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.0
    }
    
    // handles animation for tapping the tableview
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
    }
}