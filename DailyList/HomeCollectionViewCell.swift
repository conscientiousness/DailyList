//
//  HomeCollectionViewCell.swift
//  DailyMind
//
//  Created by Jesselin on 2016/3/16.
//  Copyright © 2016年 iCircle. All rights reserved.
//

import UIKit
import CoreData

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var cellContentView: SpringView!
    @IBOutlet weak var dataListView: UIView!
    @IBOutlet weak var emptyView: UIView!
    
    var itemsArray = [PageItem]()
    
    var fetchedResultsController: NSFetchedResultsController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = CustomColors.getBackgroundColor()
        self.taskTableView.registerNib(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.taskTableView.separatorStyle = .None
        self.taskTableView.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        
        self.cellContentView.fullyRound(8, borderColor: nil, borderWidth: nil)
        self.cellContentView.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        
        self.dataListView.backgroundColor = CustomColors.getTextFieldBgGreyColor()
    }
    
    func configCell(indexPath: NSIndexPath, currentDate: NSDate) {
        
        let imgName: String = "empty_photo\((indexPath.row % 6) + 1)"
        self.emptyImageView.image = UIImage(named: imgName)
        
        let date = DateCenter.getCurrentDateWithCellIndex(indexPath.row, date: currentDate)
        self.emptyLabel.text = "You have nothing on \(date.month)/\(date.day)"
        
        setFetchedResults(currentDate)
        attemptFetch()
    }
    
    func attemptFetch() {
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error), \(error.userInfo)")
        }
    }
    
    func setFetchedResults(currentDate: NSDate) {
        
        let fetchRequest = NSFetchRequest(entityName: "Page")
        fetchRequest.predicate = NSPredicate(format:"pageDate == %@", "\(DateCenter.getDateString(currentDate))")
        let sortDescriptor = NSSortDescriptor(key: "pageDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var pages = [Page]()
        do {
            pages = try ad.managedObjectContext.executeFetchRequest(fetchRequest) as! [Page]
        } catch {}
        
        if let page: Page = pages.first {
            if let pageItems = page.pageItems {
                self.itemsArray = pageItems.allObjects as! [PageItem]
            }
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ad.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultsController = controller
    }
}

extension HomeCollectionViewCell: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.itemsArray.count > 0 {
            self.taskTableView.hidden = false
            self.emptyView.hidden = true
            return self.itemsArray.count
        }
        
        self.taskTableView.hidden = true
        self.emptyView.hidden = false
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TaskTableViewCell
        
        cell.configCell(indexPath, pageItem: self.itemsArray[indexPath.row])
        
        return cell
    }
}

extension HomeCollectionViewCell: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180;
    }
}

extension HomeCollectionViewCell: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.taskTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.taskTableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
        case .Insert:
            if let indexPath = newIndexPath {
                self.taskTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Delete:
            if let indexPath =  indexPath {
                self.taskTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Update:
//            if let indexPath = indexPath {
//                let cell = tableView.cellForRowAtIndexPath(indexPath) as! ItemCell
//                configureCell(cell, indexPath: indexPath)
//            }
            break
        case .Move:
            if let indexPath = indexPath  {
                self.taskTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                self.taskTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break
        }
    }
}
