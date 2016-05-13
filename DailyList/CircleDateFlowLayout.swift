//
//  CircleDateFlowLayout.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/13.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import UIKit

class CircleDateFlowLayout: UICollectionViewFlowLayout {
    private var lastCollectionViewSize: CGSize = CGSizeZero
    
    static func configureLayout(collectionView collectionView: UICollectionView, itemSize: CGSize, minimumLineSpacing: CGFloat) -> CircleDateFlowLayout {
        let layout = CircleDateFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateNormal
        collectionView.collectionViewLayout = layout
        
        return layout
    }

}
