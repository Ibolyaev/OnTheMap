//
//  ListViewController.swift
//  On the map
//
//  Created by Admin on 11.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var studentLocations: [StudentLocation] = [StudentLocation]()
   
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        refreshButton.target = self
        refreshButton.action = "refresh:"
        
        let addButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "addLocation:")
        
        self.navigationItem.rightBarButtonItems?.append(addButton)
        
        loadLocations()
        
    }
    
    func addLocation(sender: UIBarButtonItem){
        println("a")
    }
    
    func refresh(sender: UIBarButtonItem) {
        loadLocations()
    }

    func loadLocations() {
        
        StudentLocationClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            
            if let studentLocations = result {
                
                self.studentLocations = studentLocations
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
                
            }else{
                
                println(error)
            }
            
        }

    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let student = self.studentLocations[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student = self.studentLocations[indexPath.row]
        var url = NSURL(string: student.mediaURL)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    
    
}
