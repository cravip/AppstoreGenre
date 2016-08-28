//
//  ViewController.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import UIKit

class ViewController: RUIViewController {

    @IBOutlet weak var slidingView: UIView!
    
    @IBOutlet weak var exploreCollectionView: UICollectionView!
    
    @IBOutlet weak var exploreTableView: UITableView!
    
    var exploreCategories : [ExploreCategory]?
    
    var animator = AnimationHandler()
    
    
    @IBOutlet weak var exploreTableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        self.fetchCategories()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
        self.navigationController?.navigationBar.hidden = false

     //   self.pushAnimator = PushAnimationHandler()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerTableViewCells() {
        self.exploreTableView.registerNib(UINib.init(nibName: Constants.Cell.exploreCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.Cell.exploreCellIdentifier)
    }
    
    // MARK: Network
    
    func fetchCategories() {
        CategoryFetcher.getCategory(nil) { (result, error) in
            if error == nil {
                self.exploreCategories = result!.exploreCategories
                self.exploreTableView.reloadData()
                self.exploreTableViewHeightConstraint.constant = self.exploreTableView.contentSize.height
            }
        }
    }
    
    


}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.exploreCategories != nil {
            return self.exploreCategories!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        // pushing category detail controller
        let categoryDetailController : CategoryDisplayViewController = UIStoryboard.init(name: Constants.StoryBoard.mainStoryBoardIdentifier, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Controller.CategoryDisplayViewController) as! CategoryDisplayViewController
        
        // pass the selected category
        let passingCategory = self.exploreCategories![indexPath.row]
        categoryDetailController.categoryPassed = passingCategory
        
        // append the headers to show at the top
        categoryDetailController.headers.append("All")
        categoryDetailController.headers.append(passingCategory.categoryName!)
        
     
        

        // take snap shots and store them in transition animator
         var rectObtained = tableView.rectForRowAtIndexPath(indexPath)
       // rectObtained = CGRectOffset(rectObtained, 0, 0)
        
        
        
        let cellBottomPoint = CGPointMake(rectObtained.origin.x, rectObtained.origin.y + rectObtained.size.height)
        let actualPoint = tableView.convertPoint(cellBottomPoint, toView: self.view)
        
        
        // top frame and bottom frame
        let topFrame = CGRectMake(0, 0, self.view.frame.size.width, actualPoint.y)
        let bottomFrame = CGRectMake(0, actualPoint.y, self.view.frame.size.width, self.view.frame.size.height - actualPoint.y)
        
        let snapshotTop = self.view.resizableSnapshotViewFromRect(topFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        let snapshotBottom = self.view.resizableSnapshotViewFromRect(bottomFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        
        
        animator.topImageView = snapshotTop
        animator.bottomImageView = snapshotBottom
        animator.seperationPoint = actualPoint.y
        
        // storing them in controller it self, so value can be obtained when popping
        self.topView = snapshotTop
        self.bottomView = snapshotBottom
        self.seperationPoint = actualPoint.y
        
        // calculating height of headers of next controller
        animator.finalTopYPoint = CGFloat((categoryDetailController.headers.count - 1 )*50 + 50)
        
       // categoryDetailController.transitioningDelegate = self

        self.navigationController?.pushViewController(categoryDetailController, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, CGFloat.init(45)))
        
        let label = UILabel.init(frame: CGRectMake(16, 8, view.frame.size.width, 30))
        label.text = "Categories"
        view.addSubview(label)
            
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.init(45)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let exploreCell : ExploreTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.Cell.exploreCellIdentifier) as! ExploreTableViewCell

        // set category name for cell
        exploreCell.categoryName.text = self.exploreCategories![indexPath.row].categoryName
        exploreCell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        return exploreCell
    }
    
}


// MARK: UIViewController Transitioning Delegate

extension ViewController : UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("called in viewcontroller")
        if operation == UINavigationControllerOperation.Push {
            animator.isPush = true
            return animator
        }
        animator.isPush = false
        return animator
    }

}
