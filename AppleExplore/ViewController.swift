//
//  ViewController.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: RUIViewController {

    @IBOutlet weak var slidingView: UIView!
    
    @IBOutlet weak var exploreCollectionView: UICollectionView!
    
    @IBOutlet weak var explorePopularView: RUIPopular!
    
    @IBOutlet weak var exploreTableView: UITableView!
    
    var exploreCategories : [ExploreCategory]?
    var appInfoData : [ExploreAppInfo]?
    
    var animator = AnimationHandler()
    
    
    @IBOutlet weak var exploreTableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.fetchCategories()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
        self.navigationController?.navigationBar.hidden = false

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    // MARK: Driver Methods
    
    func setUpViews() {
        
        self.registerTableViewCells()
        self.registerCollectionViewCells()
        

    }
    func registerTableViewCells() {
        self.exploreTableView.registerNib(UINib.init(nibName: Constants.Cell.exploreCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.Cell.exploreCellIdentifier)
    }
    
    func registerCollectionViewCells() {
        self.explorePopularView.collectionView.registerNib(UINib(nibName: Constants.Cell.appInfoCellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.Cell.appInfoCellIdentifier)
        self.explorePopularView.collectionView.dataSource = self
        self.explorePopularView.collectionView.delegate = self
    }
    
    
    // MARK: Network
    
    func fetchCategories() {
        CategoryFetcher.getCategory(nil) { (result, error) in
            if error == nil {
                self.exploreCategories = result!.exploreCategories
                self.exploreTableView.reloadData()
                self.exploreTableViewHeightConstraint.constant = self.exploreTableView.contentSize.height
                
                // fetch app info
                CategoryFetcher.getAppsInfo(result!.popularApps!, completion: { (result, error) in
                    if error == nil {
                        self.appInfoData = result
                        self.explorePopularView.collectionView.reloadData()
                    }
                })
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
         let rectObtained = tableView.rectForRowAtIndexPath(indexPath)
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
        view.backgroundColor = UIColor.lightGrayColor()
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

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.appInfoData?.count > 0 {
            return self.appInfoData!.count
        }
        return 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Cell.appInfoCellIdentifier, forIndexPath: indexPath) as! AppInfoCollectionViewCell
        
        cell.titleLabel.text = self.appInfoData![indexPath.item].appName
        cell.detailLabel.text = self.appInfoData![indexPath.item].appOwner
        if let imgURL = self.appInfoData![indexPath.item].appImageUrl {
            cell.imageView.kf_setImageWithURL(imgURL)
        }
        return cell
    }
    
}
