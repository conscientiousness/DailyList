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
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    //MARK: properties
    private var flowLayout: LGHorizontalLinearFlowLayout!
    private var currentDate :NSDate = NSDate()
    private var firstLaunch = true
    
    //MARK: getter & setter
    private var pageWidth: CGFloat {
        return self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing
    }
    
    private var itemCGSize: CGSize {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSizeMake(screenSize.size.width*0.86, self.collectionView.bounds.size.height*0.85)
    }
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewController()
        self.configureCollectionView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 移動到今天的cell
        if(firstLaunch) {
            firstLaunch = false
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: NSDate().day - 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
        }
    }
    
    //MARK: private method
    private func configureViewController() {
        self.view.backgroundColor = CustomColors.getBackgroundColor()
        self.dayLabel.textColor = CustomColors.getMainColor()
        self.yearMonthLabel.textColor = CustomColors.getMainColor()
        self.weekLabel.textColor = CustomColors.getMainColor()
    }
    
    private func configureCollectionView() {
        
        self.collectionView!.registerNib(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.flowLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: self.itemCGSize, minimumLineSpacing: -23)
        self.collectionView.backgroundColor = UIColor.clearColor()
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
        self.currentDate = DateCenter.getCurrentDate(self.currentDate, currentCellIdx: currentIdx)
        self.dayLabel.text = String(self.currentDate.day)
    }
}


//MARK: UICollectionViewDelegate
extension HomeVC: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentDate.monthDays;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    /*
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
     
     return CGSizeMake(collectionView.bounds.width*0.8, collectionView.bounds.height*0.8)
     }
     
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
     
     return 20;
     }
     */
}

//MARK: UIScrollViewDelegate
extension HomeVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.updateDateTitleLabel()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.updateDateTitleLabel()
        //print("scrollViewDidEndScrollingAnimation")
    }
}
