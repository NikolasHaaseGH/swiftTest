//
//  eventMenuViewController.swift
//  swiftTest
//
//  Created by Nikolas Haase on 30.01.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import UIKit

class EventTableView: UITableView{
    var presentingDate = Date()
    var presentingDateString: String{
        get{
            return presentingDate.convertToString(withFormat: "d MMM")
        }
    }
    
}

protocol pagingDelegate{
    
    func pageDidChangeTo(_ page: Int)
}

class pageControl{
    //Delegates
    var delegate : pagingDelegate?
    
    //Init
    let pageBuffer: Int
    let initialPage: Int
    
    init(pageBuffer: Int, initialPage: Int) {
        self.pageBuffer = pageBuffer
        self.initialPage = initialPage
    }
    
    //Variables
    var dictOfLoadedPages = [Int: EventTableView]()
    var dictOfLoadedTitles = [Int: Date]()
    var titleIsToggled = false
    
    enum Direction: String{
        case forwards
        case backwards
    }
    
    var direction = Direction.forwards
    var lastPage = 0
    var currentPage = 0{
        willSet(newValue){
            if newValue > currentPage || newValue < currentPage{
                direction = newValue > currentPage ? .forwards : .backwards
                
                lastPage = currentPage
                delegate?.pageDidChangeTo(newValue)
            }
        }
    }
    
}

class eventMenuViewController: UIViewController, UIScrollViewDelegate, pagingDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleButton: UIButton!
    private let eventList = EventList()
    private let eventCellNib = UINib.init(nibName: "eventTVCell", bundle: nil)
    private let pager = pageControl(pageBuffer: 2, initialPage: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        pager.delegate = self
        loadPagesFromInitialPage(pager.initialPage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func titleButtonPressed(_ sender: UIButton) {
        pager.titleIsToggled = pager.titleIsToggled ? false : true
        updateTitle(pager.currentPage)
    }
    //MARK: PAGING////////////////////////////////////////////
    func loadPagesFromInitialPage(_ page: Int){
        
        let buffer = pager.pageBuffer
        
        for pg in page-buffer...page+buffer{
            pg >= 0 ? loadPageAt(pg) : print("page out of scope")
        }
        updateContentSize(page+pager.pageBuffer+1)
        updateContentOffset(page)
        updateTitle(page)
    }
    
    func reloadInitialPagesForDate(_ date: Date){
        
        let page = Date().getDifferenceOfDaysTo(date)
        print(page)
        
        //clean up for new Initination
        pager.dictOfLoadedPages.forEach() { item in
            item.value.removeFromSuperview()
        }
        pager.dictOfLoadedPages.removeAll()
        
        //load new pages
        loadPagesFromInitialPage(page)
    }
    
    func loadPageAt(_ page: Int){
        
        if pager.dictOfLoadedPages.keys.contains(page) {
            scrollView.addSubview(pager.dictOfLoadedPages[page]!)
        }
        else{
            //create new page and add to dicitonary
            let frame = CGRect(x: scrollView.frame.width * CGFloat(page), y: 0.0, width: scrollView.frame.width, height: scrollView.frame.height)
            let tableView:EventTableView = EventTableView(frame: frame, style: .plain)
            if (self.eventList.eventsForDate(date: Date().dateForDaysFromNow(days: page)) != nil){
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor.clear
            }
            tableView.register(self.eventCellNib, forCellReuseIdentifier: "eventTVCell")
            tableView.presentingDate = Date().dateForDaysFromNow(days: page)
            pager.dictOfLoadedPages[page] = tableView
            scrollView.addSubview(tableView)
        }
    }
    
    func removePage(_ page: Int){
        pager.dictOfLoadedPages[page]?.removeFromSuperview()
    }
    
    func pageDidChangeTo(_ page: Int){
        updateTitle(page)
        
        switch pager.direction {
        case .forwards:
            loadPageAt(page + pager.pageBuffer)
            removePage(page - pager.pageBuffer - 1)
            updateContentSize(page+pager.pageBuffer)
        case .backwards:
            loadPageAt(page - pager.pageBuffer)
            removePage(page + pager.pageBuffer + 1)
            updateContentSize(page + pager.pageBuffer)
        }
    }
    
    
    func updateTitle(_ page: Int){
        let date = Date().dateForDaysFromNow(days: page)
        let title = pager.titleIsToggled ? date.convertToString(withFormat: "EEEE") : date.convertToString(withFormat: "d. MMM")
        titleButton.setTitle(title, for: .normal)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue")
    }
    
    @IBAction func unwindToMenu(segue:UIStoryboardSegue) {
    }
    
    //MARK: SCROLLVIEW////////////////////////////////////////
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 1{
            let pageWidth = scrollView.frame.width
            let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            pager.currentPage = Int(page)
        }
    }
    
    func updateContentSize(_ rangeOfPages: Int){
        let size = CGSize(width: scrollView.frame.width * CGFloat(rangeOfPages), height: scrollView.frame.height)
        scrollView.contentSize = size
    }
    
    func updateContentOffset(_ page: Int){
        let offset = CGPoint(x: scrollView.frame.width * CGFloat(page), y: 0.0)
        scrollView.setContentOffset(offset, animated: false)
    }
}

// MARK: - Table view delegate & data source
extension eventMenuViewController{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (eventList.eventsForDate(date: (tableView as! EventTableView).presentingDate)?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTVCell", for: indexPath) as! eventTVCell
        //print(eventList.eventsForDate(date: (tableView as! EventTableView).presentingDate)!)
        for index in indexPath{
            let event = eventList.eventsForDate(date: (tableView as! EventTableView).presentingDate)![index]
            cell.eventNameLabel.text = event.name
            cell.placeNameLabel.text = event.location?.name
            cell.timeLabel.text = (event.startTime?.convertToString(withFormat: "hh:mm"))! + " - " + (event.endTime?.convertToString(withFormat: "hh:mm"))!
            cell.locationLabel.text = event.location?.street
        }
        
        return cell
    }
}




extension Date{
    
    func convertToString(withFormat format: String)-> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let myString = formatter.string(from: self)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = format
        // again convert your date to string
        let finalString = formatter.string(from: yourDate!)
        
        return finalString
    }
    
    func dateForDaysFromNow(days: Int) -> Date{
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func getDifferenceOfDaysTo(_ date: Date) -> Int{
        
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day!
    }
    
}
