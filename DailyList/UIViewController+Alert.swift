//
//  UIViewController+Alert.swift
//  DailyList
//
//  Created by Jesselin on 2016/6/8.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(action: (() -> Void)? = nil) {
        
        let alert = UIAlertController(
            title: nil,
            message: "請輸入任務名稱",
            preferredStyle: .Alert
        )
        alert.addAction(UIAlertAction(title: "好的", style: .Default) { _ in
            action?()
            })
        presentViewController(alert, animated: true, completion: nil)
    }
    
}