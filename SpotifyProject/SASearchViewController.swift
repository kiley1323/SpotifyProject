//
//  SASearchViewController.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/6/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import UIKit

class SASearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, communicationControllerArtist {

    @IBOutlet var tableView: UITableView!
    var SAArtistArray: [SAArtist] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupSearchController()
    }
    
    func setupSearchController () {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.tintColor = UIColor.blackColor()
        searchController.searchBar.barTintColor = UIColor.blackColor()
        searchController.searchBar.backgroundColor = UIColor.blackColor()
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes (cancelButtonAttributes as? [String: AnyObject], forState: UIControlState.Normal)
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return self.SAArtistArray.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomSearchViewCell
        if searchController.active && searchController.searchBar.text != "" {
            cell.artistName.text! = SAArtistArray[indexPath.row].name
        }
        else {
        }
        
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchController.searchBar.endEditing(true)
        searchController.active = false
        
        let SAArtistDestination = self.storyboard?.instantiateViewControllerWithIdentifier("SAArtistViewController") as! SAArtistViewController
        let currentCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!) as! CustomSearchViewCell
        let textFromCell = currentCell.artistName.text!
        
        //Sending the artist's instance to SAArtistVC
        for artistValue in self.SAArtistArray {
            if artistValue.name == textFromCell {
                SAArtistDestination.SAArtistObj = artistValue
                break
            }
        }
        
        SAArtistDestination.delegate = self
        self.presentViewController(SAArtistDestination, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchController.searchBar.text != "" && searchController.active {
            SARequestManager().searchArtists(searchController.searchBar.text,  completion: {artistInfo in
                self.SAArtistArray = artistInfo as! [SAArtist]
                self.tableView.reloadData()
            })
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func backFromArtist() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}


