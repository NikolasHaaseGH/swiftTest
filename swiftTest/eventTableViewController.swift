//
//  eventTableViewController.swift
//  swiftTest
//
//  Created by Nikolas Haase on 23.01.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import UIKit

class eventTableViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate, EventListDelegate {
    
    
    @IBOutlet private weak var navigationBar: UINavigationBar!
    private var eventList: EventList!
    private var pages = Array<UITableView?>()
    private var arrayOfTitles = Array<String>()
    @IBOutlet private weak var scrollView: UIScrollView!
    private let pageRange = 5 //amount Of Pages displayed at once
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventList = EventList()
        eventList.delegate = self
        
        
        loadInitialPages(pageRange: pageRange)
        
        //height normal, and content width is one screenwidth times the amount of tableViews to present
        //self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * CGFloat(pages.count),height: self.scrollView.frame.size.height)
    }


    // MARK: - EventList Delegate
    func didLoadEvents() {
        //currentTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    // MARK: - Paging
    private var currentPage: Int!{
        didSet{
            if currentPage >= pages.count - 1{
                addPageAtIndex(index: pages.count)
                removePageAtIndex(index: 0)
            }
        }
    }
    
    func loadInitialPages(pageRange range: Int){
        for index in 0..<pageRange{
            loadPage(index)
        }
        
        adjustScrollView()
    }
    
    fileprivate func loadPage(_ page: Int) {
        
        if pages.count <= page {
            let scrollViewFrame = scrollView.frame
            let newFrame = CGRect(x: scrollViewFrame.size.width * CGFloat(page), y: 0.0, width: scrollViewFrame.size.width, height: scrollViewFrame.size.height)
            let tableView = UITableView(frame: newFrame, style: .plain)
            tableView.delegate = self
            
            let dateTitle = Date().dateForDaysFromNow(days: pages.count)
            tableView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8631474743)
            
            scrollView.addSubview(tableView)
            pages.append(tableView)
            arrayOfTitles.append(dateTitle.convertToString(withFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"))
        }
    }
    
    fileprivate func addPageAtIndex(index: Int){
    
        loadPage(index)
        adjustScrollView()
    }
    
    fileprivate func removePageAtIndex(index: Int){
        
        //clean up
        pages[index]?.removeFromSuperview()
        pages.remove(at: index)
        adjustScrollView()
    }
    
    // MARK: - Scroll view
    
    /// Readjust the scroll view's content size in case the layout has changed.
   
    
    fileprivate func adjustScrollView() {
        scrollView.contentSize =
            CGSize(width: scrollView.frame.width * CGFloat(pages.count),
                   height: scrollView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Switch the indicator when more than 50% of the previous/next page is visible.
        let pageWidth = scrollView.frame.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        currentPage = Int(page)
        navigationBar.topItem?.title = arrayOfTitles[Int(page)]
        print(currentPage)
    }
    
    /// Convert Date to String
    func convertToString(withFormat format: String, date: Date) -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = format
        
        let myString = formatter.string(from: Date())
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let finalString = formatter.string(from: yourDate!)
        
        return finalString
    }
    
    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }

}

extension Date{
    
    func convertToString(withFormat format: String)-> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = format
        
        let myString = formatter.string(from: self)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let finalString = formatter.string(from: yourDate!)
        
        return finalString
    }
    
    func dateForDaysFromNow(days: Int) -> Date{
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
