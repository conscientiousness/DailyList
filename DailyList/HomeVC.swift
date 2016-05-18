//
//  ViewController.swift
//  DailyMind
//
//  Created by Jesselin on 2016/3/15.
//  Copyright © 2016年 iCircle. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    // @IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightCT: NSLayoutConstraint!
    @IBOutlet weak var circleDateCollectionView: UICollectionView!
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var addButtonWidthCT: NSLayoutConstraint!

    //MARK: properties
    private let transitionManager = TransitionManager()
    private var currentDate :NSDate = NSDate()
    private var firstLaunch = true
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    enum ScreenHeight: CGFloat {
        case ip4 = 480.0
        case ip5 = 568.0
        case ip6 = 667.0
        case ip6Plus = 736.0
    }
    
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
        return CGSizeMake(screenSize.size.width*0.86, cvh)
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
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: NSDate().day - 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
            self.circleDateCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: NSDate().day - 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
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
        self.collectionView.collectionViewLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: self.itemCGSize, minimumLineSpacing: -23)
        self.collectionView.backgroundColor = UIColor.clearColor()
        
        // config circle date Collection View
        self.circleDateCollectionView.registerNib(UINib(nibName: "CircleDateCollectionCell", bundle: nil), forCellWithReuseIdentifier: "circleDateCollectionCell")
        self.circleDateCollectionView.collectionViewLayout = CircleDateFlowLayout.configureLayout(collectionView: self.circleDateCollectionView, itemSize: self.circleDateItemCGSize, minimumLineSpacing: 10)
        self.circleDateCollectionView.backgroundColor = UIColor.clearColor()

        self.navigationController?.navigationBarHidden = true
    }
    
    private func getCurrentCellRow() -> Int {
        
        var rowAry = [Int]()
        for cell in self.collectionView.visibleCells() {
            let indexPath: NSIndexPath? = self.collectionView.indexPathForCell(cell)
            if let ip = indexPath {
                rowAry.append(ip.row)
            }
        }
        rowAry = rowAry.sort()
        //print("rowAry = \(rowAry))")
        if(rowAry.count == 3) {
            return rowAry[1]
        }
        else if(rowAry.count == 2) {
            return rowAry[0] == 0 ? 0:rowAry[1]
        }
        
        return rowAry[0]
    }
    
    private func updateDateTitleLabel() {
        //print("cell idx = \(self.getCurrentCellRow())")
        let currentIdx = self.getCurrentCellRow()
        self.currentDate = DateCenter.getCurrentDateWithCellIndex(currentIdx, date: self.currentDate)
        //self.dayLabel.text = String(self.currentDate.day)
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
                if((indexPath.row + 1) != self.currentDate.day) {
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
            addTaskVC.currentDate = self.currentDate
            addTaskVC.transitioningDelegate = self.transitionManager
        }
    }
    
    //MARK: date delegate
    func didChangeCurrentDate(date: NSDate) {
        print("This is delegate date = \(date)")
        self.currentDate = date
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
            cell.configCell(indexPath, currentDate: self.currentDate)
            
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
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if let view: UIView = scrollView.subviews.first {
            
            let className = NSStringFromClass(view.classForCoder).componentsSeparatedByString(".").last!
            if(className == "HomeCollectionViewCell") {
                
                let indexPath: NSIndexPath = NSIndexPath(forRow: self.getCurrentCellRow(), inSection: 0)
                // 同步移動快捷日曆列
                self.circleDateCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
                self.collectionView(self.circleDateCollectionView, didSelectItemAtIndexPath: indexPath)
            }
            
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    }
}
