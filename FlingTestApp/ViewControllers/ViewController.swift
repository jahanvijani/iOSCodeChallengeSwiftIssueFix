//
//  ViewController.swift
//  FlingTestApp
//
//  Created by Jahanvi Vyas on 10/04/2016.
//  Copyright © 2016 Jahanvi Vyas. All rights reserved.
//

let kFeedCellIdentifier = "FeedTableViewCellIdentifier"

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var loadingIndicator: UIActivityIndicatorView!
    
    var feeds : NSMutableArray = [ ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get feed data from server
        self.tableView.hidden = true
        self.showLoading()
        FeedDataManager.sharedInstance.getFeedDataWithCompletion {(error) -> Void in
            
            dispatch_async(dispatch_get_main_queue())
            {
                if((error) == nil)
                {
                    //Update UITableView with Feed Data
                    self.feeds = FeedDataManager.sharedInstance.feeds
                    self.tableView.reloadData()
                }
                else
                {
                    //No Internet connection
                    if(error?.code == kNoInternetErrorCode)
                    {
                        self.showErrorMessage("No Internet Connection. Showing last updated data")
                        
                        //Update UITableView with Feed Data from core data
                        self.feeds = FeedDataManager.sharedInstance.feeds
                        self.tableView.reloadData()
                    }
                    else //Problem in load data from server
                    {
                        self.showErrorMessage("Problem in server to load data")
                    }
                }
                self.tableView.hidden = false
                self.hideLoading()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Show Error messages in AlertView
    func showErrorMessage(message:String) {
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    //Show loading indicator
    func showLoading() {
        
        if(loadingIndicator == nil)
        {
            loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            loadingIndicator.center = view.center
            loadingIndicator.hidesWhenStopped = true
            view.addSubview(loadingIndicator)
        }
        loadingIndicator.startAnimating()
    }
    
    //Hide loading indicator
    func hideLoading() {
        
        loadingIndicator.stopAnimating()
    }

    // MARK: - UITableViewDataSource Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kFeedCellIdentifier, forIndexPath: indexPath) as! FeedTableViewCell
        
        let feed = feeds[indexPath.row] as! Feed
        cell.photoLabel.text = feed.photoTitle
        cell.photoImageView.image = nil
        cell.loadingIndicator.hidden = false
        if(feed.photoImage == nil)
        {
            cell.loadingIndicator.startAnimating()
            //Load image from image ID
            FeedDataManager.sharedInstance.downloadImageWithCompletion(feed.photoID!,completionHandler: { ( sucess) -> Void in
                if (sucess == true) {
                    
                    dispatch_async(dispatch_get_main_queue())
                    {
                        cell.photoImageView.image = UIImage(data: feed.photoImage!)
                        cell.loadingIndicator.stopAnimating()
                        cell.loadingIndicator.hidden = true
                    }
                }
            })
        }
        else
        {
            cell.loadingIndicator.stopAnimating()
            cell.loadingIndicator.hidden = true
            cell.photoImageView.image = UIImage(data: feed.photoImage!)
        }
        return cell
    }
}

