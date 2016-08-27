//
//  ViewController.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slidingView: UIView!
    
    @IBOutlet weak var exploreCollectionView: UICollectionView!
    
    @IBOutlet weak var exploreTableView: UITableView!
    
    var exploreCategories : [ExploreCategory]?
    
    @IBOutlet weak var exploreTableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        self.fetchCategories()
        
        // Do any additional setup after loading the view, typically from a nib.
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
        exploreCell.categoryName.text = self.exploreCategories![indexPath.row].categoryName
        // set category name for cell
        
        
        return exploreCell
    }
    
}
