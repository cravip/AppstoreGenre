//
//  PushAnimationHandler.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import Foundation
import UIKit

class AnimationHandler : NSObject, UIViewControllerAnimatedTransitioning {
    
    var topImageView : UIView?
    var bottomImageView : UIView?
    var seperationPoint : CGFloat?
    var finalTopYPoint : CGFloat?
    var isPush  = true
    
     func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    // handles animation for tapping the tableview
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // get references to view hierarchy
        let contextContainer = transitionContext.containerView()
        let sourceController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! RUIViewController
        let destinationController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! RUIViewController
        
        var topView : UIView?
        var bottomView : UIView?
        var seperationY : CGFloat?
        if self.isPush {
            topView = self.topImageView
            bottomView = self.bottomImageView
            seperationY = self.seperationPoint
        }else {
            topView = destinationController.topView
            bottomView = destinationController.bottomView
            seperationY = destinationController.seperationPoint
        }
        
        sourceController.view.removeFromSuperview()
        
        contextContainer?.addSubview((destinationController.view))
        
        if !self.isPush {
            contextContainer?.addSubview(sourceController.view)
        }
        contextContainer?.addSubview(topView!)
        contextContainer?.addSubview(bottomView!)
        destinationController.view.alpha = 0.2
        
        
        if self.isPush {

            topView?.frame = CGRectMake(0, 0, topView!.frame.size.width, topView!.frame.size.height)
            bottomView?.frame = CGRectMake(0, seperationY!, bottomView!.frame.size.width, bottomView!.frame.size.height)

        }else {
            topView?.frame = CGRectMake(0, -topView!.frame.size.height, topView!.frame.size.width, topView!.frame.size.height)
            bottomView?.frame = CGRectMake(0, seperationY! + bottomView!.frame.size.height, bottomView!.frame.size.width, bottomView!.frame.size.height)

        }

        
        //animate
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            let topFrame = topView!.frame
            let bottomFrame = bottomView!.frame
            if self.isPush {
                let finalY = (self.finalTopYPoint! - topFrame.size.height)
                topView?.frame = CGRectMake(topFrame.origin.x, finalY, topFrame.size.width, topFrame.size.height)
                bottomView?.frame = CGRectMake(bottomFrame.origin.x, destinationController.view.frame.size.height, bottomFrame.size.width, bottomFrame.size.height)
            }else {
                topView?.frame = CGRectMake(topFrame.origin.x, 0, topFrame.size.width, topFrame.size.height)
                bottomView?.frame = CGRectMake(bottomFrame.origin.x, seperationY!, bottomFrame.size.width, bottomFrame.size.height)

            }
            
            
            
            destinationController.view.alpha = 1.0
            
            }, completion: { (finished) in
                topView!.removeFromSuperview()
                bottomView!.removeFromSuperview()
                if !self.isPush {
                    sourceController.view.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
                
        })
    }
}