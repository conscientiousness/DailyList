//
//  ViewController.swift
//  DailyMind
//
//  Created by Jesselin on 2016/3/15.
//  Copyright © 2016年 iCircle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // @IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    // properties
    private var flowLayout: LGHorizontalLinearFlowLayout!
    private var currentIdx :Int?
    private var _lastVisableCellIdx :Int?
    private var _currentDate :NSDate?
    
    // getter & setter
    private var pageWidth: CGFloat {
        return self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing
    }
    
    private var contentOffset: CGFloat {
        return self.collectionView.contentOffset.x + self.collectionView.contentInset.left
    }
    
    private var itemCGSize: CGSize {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSizeMake(screenSize.size.width*0.75, self.collectionView.bounds.size.height*0.7)
    }
    
    private var currentDate: NSDate {
        get {
            if let cd = _currentDate {
                //let date: NSDate = DateCenter.currentDate(cd, calDayNumber: self.getCurrentIdx() - self.getLastIdx())
                //_currentDate = date
                return cd
            }
            else {
                let date: NSDate = NSDate()
                _currentDate = date
                return date
            }
        }
        
        set {
            _currentDate = newValue
        }
    }
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewController()
        self.configureCollectionView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: NSDate().day - 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
        
    }
    
    private func configureViewController() {
        self.view.backgroundColor = CustomColors.getBackgroundColor()
        self.dateLabel.textColor = CustomColors.getMainColor()
        self.yearMonthLabel.textColor = CustomColors.getMainColor()
        self.weekLabel.textColor = CustomColors.getMainColor()
    }
    
    private func configureCollectionView() {
        
        self.collectionView!.registerNib(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.flowLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: self.itemCGSize, minimumLineSpacing: -5)
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBarHidden = true
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        print("scroll didi end animation")
    }
}

extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        print("cell idx = \(indexPath.row)")
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    /*
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
     
     return CGSizeMake(collectionView.bounds.width*0.8, collectionView.bounds.height*0.8)
     }
     
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
     
     return 20;
     }
     */
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        var rowAry = [Int]()
        for cell in self.collectionView.visibleCells() {
            let indexPath: NSIndexPath? = self.collectionView.indexPathForCell(cell)
            if let ip = indexPath {
                rowAry.append(ip.row)
            }
        }
        
        rowAry = rowAry.sort()
    }
}
