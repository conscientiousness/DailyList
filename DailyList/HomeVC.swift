//
//  ViewController.swift
//  DailyMind
//
//  Created by Jesselin on 2016/3/15.
//  Copyright © 2016年 iCircle. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {
    
    // @IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightCT: NSLayoutConstraint!
    @IBOutlet weak var circleDateCollectionView: UICollectionView!
    @IBOutlet weak var yearMonthLabel: DesignableLabel!
    @IBOutlet weak var addButton: DesignableButton!
    @IBOutlet weak var addButtonWidthCT: NSLayoutConstraint!

    //MARK: properties
    enum ScreenHeight: CGFloat {
        case ip4 = 480.0
        case ip5 = 568.0
        case ip6 = 667.0
        case ip6Plus = 736.0
    }
    
    enum ScrollDirection {
        case right,left
    }
    
    private let transitionManager = TransitionManager()
    private let currentDate = CurrentDate.sharedInstance.nowDate
    private var firstLaunch = true
    private var lastContentOffset: CGFloat = 0
    private var scrollDirection: ScrollDirection = .right
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var itemsArray = [PageItem]()
    var fetchedResultsController: NSFetchedResultsController!
    
    //MARK: getter & setter
    private var itemCGSize: CGSize {
        var cvh = self.collectionView.bounds.size.height;
        
        if let screenHeight = ScreenHeight(rawValue: screenSize.height) {
            switch screenHeight {
            case .ip4:
                cvh = cvh * 0.75
            case .ip5:
                cvh = cvh * 0.9
            case .ip6Plus:
                cvh = self.collectionView.bounds.size.height + 80
            default:
                cvh = self.collectionView.bounds.size.height + 20;
            }
        }
        return CGSizeMake(screenSize.size.width * 0.8, cvh)
    }
    
    private var circleDateItemCGSize: CGSize {
        var circleCVHeight: CGFloat = self.circleDateCollectionView.frame.size.height
        if let screenHeight = ScreenHeight(rawValue: screenSize.height) {
            switch screenHeight {
            case .ip4:
                circleCVHeight = circleCVHeight * 0.64
            case .ip5:
                circleCVHeight = circleCVHeight * 0.7
            default:
                circleCVHeight = circleCVHeight * 0.8;
            }
        }
        return CGSizeMake(circleCVHeight, circleCVHeight)
    }
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configLayout()
        self.configViewController()
        self.configCollectionView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 移動到今天的cell
        if(firstLaunch) {
            firstLaunch = false
            let indexPath: NSIndexPath = NSIndexPath(forRow: NSDate().day - 1, inSection: 0)
            if indexPath.row < 3 {
                self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
            } else {
                let indexPathBefore: NSIndexPath = NSIndexPath(forRow: NSDate().day - 3, inSection: 0)
                self.collectionView.scrollToItemAtIndexPath(indexPathBefore, atScrollPosition: .CenteredHorizontally, animated: false)
                UIView.animateWithDuration(1.0, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .CurveLinear, animations: {
                        self.collectionView.alpha = 1
                        self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
                        self.circleDateCollectionView.alpha = 1
                        self.circleDateCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
                    }, completion: { (finish: Bool) in
                        if finish {
                            self.yearMonthLabel.hidden = false
                            self.yearMonthLabel.animation = "zoomIn"
                            self.yearMonthLabel.animate()
                            
                            self.addButton.alpha = 1;
                            self.addButton.animation = "fadeInUp"
                            self.addButton.curve = "spring"
                            self.addButton.animate()
                        }
                })
            }
        }
        
    }
    
    //MARK: private method
    private func configLayout() {
        if let screenHeight = ScreenHeight(rawValue: screenSize.height) {
            switch screenHeight {
            case .ip4:
                self.addButtonWidthCT.constant = 30
            case .ip5:
                self.addButtonWidthCT.constant = 40
            default:
                self.addButtonWidthCT.constant = 44
            }
        }
    }
    
    private func configViewController() {
        
        self.view.backgroundColor = CustomColors.getBackgroundColor()
        
        self.addButton.alpha = 0
        
        self.yearMonthLabel.hidden = true
        self.yearMonthLabel.textColor = CustomColors.getMainColor()
        self.yearMonthLabel.text = "\(self.currentDate.year)年\(self.currentDate.month)月"
        if let screenHeight = ScreenHeight(rawValue: screenSize.height) {
            switch screenHeight {
            case .ip4:
                self.yearMonthLabel.font = UIFont(name: "NotoSansCJKtc-Medium", size:12)
            case .ip5:
                self.yearMonthLabel.font = UIFont(name: "NotoSansCJKtc-Medium", size:16)
            default:
                self.yearMonthLabel.font = UIFont(name: "NotoSansCJKtc-Medium", size:19)
            }
        }
    }
    
    private func configCollectionView() {
        
        // config main Collection View
        self.collectionView.registerNib(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionViewCell")
        self.collectionView.collectionViewLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: self.itemCGSize, minimumLineSpacing: -15)
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.alpha = 0
        
        // config circle date Collection View
        self.circleDateCollectionView.registerNib(UINib(nibName: "CircleDateCollectionCell", bundle: nil), forCellWithReuseIdentifier: "circleDateCollectionCell")
        self.circleDateCollectionView.collectionViewLayout = CircleDateFlowLayout.configureLayout(collectionView: self.circleDateCollectionView, itemSize: self.circleDateItemCGSize, minimumLineSpacing: 10)
        self.circleDateCollectionView.backgroundColor = UIColor.clearColor()
        self.circleDateCollectionView.alpha = 0

        self.navigationController?.navigationBarHidden = true
    }
    
    private func getCenterCellRow() -> Int? {
        
        var rowAry = [Int]()
        for cell in self.collectionView.visibleCells() {
            let indexPath: NSIndexPath? = self.collectionView.indexPathForCell(cell)
            if let ip = indexPath {
                rowAry.append(ip.row)
            }
        }
        rowAry = rowAry.sort()
        //print("rowAry = \(rowAry))")
        if rowAry.count == 3 {
            return rowAry[1]
        }
        else if rowAry.count == 2 {

            return self.scrollDirection == .right ? rowAry[0]:rowAry[1]
        }
        
        return nil
    }
    
    private func changeCellBgColorWithIndexPath(indexPath: NSIndexPath, didSelected: Bool) {
        
        if(didSelected) {
            let cell = self.circleDateCollectionView.cellForItemAtIndexPath(indexPath) as? CircleDateCollectionCell
            if let cell = cell {
                cell.backgroundColor = CustomColors.getLightGreenColor()
            }
            for i in 0 ... (self.currentDate.monthDays - 1) {
                if indexPath.row != i {

                    let deIndexPath: NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
                    self.collectionView(self.circleDateCollectionView, didDeselectItemAtIndexPath: deIndexPath)
                }
            }
        }
        else {
            let cell = self.circleDateCollectionView.cellForItemAtIndexPath(indexPath) as? CircleDateCollectionCell
            if let cell = cell {
                if((indexPath.row + 1) != NSDate().day) {
                    cell.backgroundColor = UIColor.clearColor()
                } else {
                    cell.backgroundColor = CustomColors.getMainColor()
                }
            }
        }
    }
    
    //MARK: prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddTaskSegue" {
            
            let addTaskVC = segue.destinationViewController as! AddTaskVC
            addTaskVC.transitioningDelegate = self.transitionManager
        }
    }
}

//MARK: UICollectionViewDelegate
extension HomeVC: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentDate.monthDays;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if(collectionView == self.collectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("homeCollectionViewCell", forIndexPath: indexPath) as! HomeCollectionViewCell
            cell.configCell(indexPath)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("circleDateCollectionCell", forIndexPath: indexPath) as! CircleDateCollectionCell
            cell.configCell(indexPath, currentDate: self.currentDate)
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(collectionView == self.circleDateCollectionView) {
            self.circleDateCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
            self.changeCellBgColorWithIndexPath(indexPath, didSelected: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(collectionView == self.circleDateCollectionView) {
            self.circleDateCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
            self.changeCellBgColorWithIndexPath(indexPath, didSelected: false)
        }
    }
}

//MARK: UIScrollViewDelegate
extension HomeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.lastContentOffset > scrollView.contentOffset.x {
            // move right
            self.scrollDirection = .right
        }
        else if self.lastContentOffset < scrollView.contentOffset.x {
            // move left
            self.scrollDirection = .left
        }
    
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.x
        
        if let idx = self.getCenterCellRow() {
            CurrentDate.sharedInstance.changeDayWithIndex(idx)
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if let view: UIView = scrollView.subviews.first {
            let className = NSStringFromClass(view.classForCoder).componentsSeparatedByString(".").last!
            if(className == "HomeCollectionViewCell") {
                self.addButton.enabled = false
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if let view: UIView = scrollView.subviews.first {
            let className = NSStringFromClass(view.classForCoder).componentsSeparatedByString(".").last!
            if(className == "HomeCollectionViewCell") {
                
                if let idx = self.getCenterCellRow() {
                    let indexPath: NSIndexPath = NSIndexPath(forRow: idx, inSection: 0)
                    // 同步移動快捷日曆列
                    self.circleDateCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
                    self.collectionView(self.circleDateCollectionView, didSelectItemAtIndexPath: indexPath)
                }
                self.addButton.enabled = true
            }
        }
    }
}

extension HomeVC: NSFetchedResultsControllerDelegate {
    
    func attemptFetch() {
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error), \(error.userInfo)")
        }
    }
    
    func setFetchedResults(currentDate: NSDate) {
        
        let fetchRequest = NSFetchRequest(entityName: "PageItem")
        fetchRequest.predicate = NSPredicate(format:"page.pageDate == %@", "\(DateCenter.getDateString(currentDate))")
        let sortDescriptor = NSSortDescriptor(key: "createDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            self.itemsArray = try ad.managedObjectContext.executeFetchRequest(fetchRequest) as! [PageItem]
            if self.itemsArray.count > 0 {
                let item: PageItem = self.itemsArray.first!
                print("COUNT = \(self.itemsArray.count), item.page = \(item.page?.pageDate), currentDate = \(DateCenter.getDateString(currentDate))")
            }
            
        } catch {}
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ad.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultsController = controller
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        //self.taskTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        //self.taskTableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
        case .Insert:
            //            if let indexPath = newIndexPath {
            //                self.taskTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            //            }
            break
        case .Delete:
            //            if let indexPath =  indexPath {
            //                self.taskTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            //            }
            break
        case .Update:
            //            if let indexPath = indexPath {
            //                let cell = tableView.cellForRowAtIndexPath(indexPath) as! ItemCell
            //                configureCell(cell, indexPath: indexPath)
            //            }
            break
        case .Move:
            //            if let indexPath = indexPath  {
            //                self.taskTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            //            }
            //
            //            if let newIndexPath = newIndexPath {
            //                self.taskTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            //            }
            break
        }
    }
}

