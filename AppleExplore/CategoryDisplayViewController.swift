//
//  CategoryDisplayViewController.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import UIKit

class CategoryDisplayViewController: RUIViewController, HeaderCommunicator {

    @IBOutlet weak var categoryDetailTableView: UITableView!
    var categoryPassed : ExploreCategory?
    
    var animator = AnimationHandler()
    
    var headers : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //headers.append("All")
        self.categoryDetailTableView.tableHeaderView = nil
        self.registerTableViewCells()


        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
        self.navigationController?.navigationBar.hidden = true


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Helpers
    
    func registerTableViewCells() {
        self.categoryDetailTableView.registerNib(UINib.init(nibName: Constants.Cell.exploreCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.Cell.exploreCellIdentifier)

        self.categoryDetailTableView.registerNib(UINib.init(nibName: Constants.Header.smallHeaderIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.Header.smallHeaderIdentifier)
        self.categoryDetailTableView.registerNib(UINib.init(nibName: Constants.Header.NormalHeaderIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.Header.NormalHeaderIdentifier)

    }
    

    
    // MARK : HeaderCommunicator 
    
    func didClickOnHeaderCell(headerCell: BaseHeaderFooterView) {
        let section = headerCell.sectionNo
        if section == (headers.count - 1 ) {
            // last section tapped
            self.navigationController?.popViewControllerAnimated(true)
        }else {
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[section!])!, animated: true)

        }
    }
    

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CategoryDisplayViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // for last section return category + collectionview rows else 0
        if section == (headers.count - 1) {
            if self.categoryPassed?.exploreCategories?.count > 0 {
                return self.categoryPassed!.exploreCategories!.count
            }
            return 0
        }else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let categoryDetailController : CategoryDisplayViewController = UIStoryboard.init(name: Constants.StoryBoard.mainStoryBoardIdentifier, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Controller.CategoryDisplayViewController) as! CategoryDisplayViewController
        let passingCategory = self.categoryPassed!.exploreCategories![indexPath.row]
        categoryDetailController.headers.appendContentsOf(headers)
        categoryDetailController.headers.append(passingCategory.categoryName!)
        categoryDetailController.categoryPassed = passingCategory
        
        
        // frame for cell clicked
        let rectObtained = tableView.rectForRowAtIndexPath(indexPath)
        
        
        // bottom point
        let cellBottomPoint = CGPointMake(rectObtained.origin.x, rectObtained.origin.y + rectObtained.size.height)
        let actualPoint = tableView.convertPoint(cellBottomPoint, toView: self.view)
        
        
        // top frame and bottom frame
        let topFrame = CGRectMake(0, 0, self.view.frame.size.width, actualPoint.y)
        let bottomFrame = CGRectMake(0, actualPoint.y, self.view.frame.size.width, self.view.frame.size.height - actualPoint.y)
        
        // take snap shots and store them in transition animator
        // top part snapshot
        let snapshotTop = self.view.resizableSnapshotViewFromRect(topFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        let snapshotBottom = self.view.resizableSnapshotViewFromRect(bottomFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        
        
        animator.topImageView = snapshotTop
        animator.bottomImageView = snapshotBottom
        animator.seperationPoint = actualPoint.y
        // calculating height of headers of next controller
        animator.finalTopYPoint = CGFloat((categoryDetailController.headers.count - 1 )*50 + 50)
        
        
        // storing them in controller it self, so value can be obtained when popping
        self.topView = snapshotTop
        self.bottomView = snapshotBottom
        self.seperationPoint = actualPoint.y

        
       // categoryDetailController.transitioningDelegate = self

        
        self.navigationController?.pushViewController(categoryDetailController, animated: true)
    }
    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == (headers.count - 1) {
            // last section
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(Constants.Header.NormalHeaderIdentifier) as! NormalHeader
            
            header.sectionNo = section
            header.titleLabel.text = headers[section]
            header.delegate = self
            return header
            
        }else {
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(Constants.Header.smallHeaderIdentifier) as! SmallHeader
            header.sectionNo = section
            header.titleLabel.text = headers[section]
            header.delegate = self
            return header

        }
     
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == (headers.count - 1) {
            return CGFloat.init(50)
        }
        return CGFloat.init(25)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let exploreCell : ExploreTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.Cell.exploreCellIdentifier) as! ExploreTableViewCell
        
        // set category name for cell
        exploreCell.categoryName.text = self.categoryPassed?.exploreCategories![indexPath.row].categoryName
        
        
        return exploreCell
    }
    
   
    
}

// MARK: UIViewController Transitioning Delegate

extension CategoryDisplayViewController : UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("called in category detail view controller")
        if operation == UINavigationControllerOperation.Push {
            animator.isPush = true
            return animator
        }
        animator.isPush = false
        return animator
    }

}