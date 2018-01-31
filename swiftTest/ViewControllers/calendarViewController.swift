//
//  calendarViewController.swift
//  swiftTest
//
//  Created by Nikolas Haase on 29.01.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import UIKit

class dayCell: UICollectionViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
}

class calendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet fileprivate weak var yearLabel: UILabel!
    @IBOutlet fileprivate weak var monthLabel: UILabel!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    fileprivate var arrayOfDays = [Int]()
    fileprivate var presetingMonth = Date(){
        didSet{
            yearLabel.text = presetingMonth.convertToString(withFormat: "yyyy")
            monthLabel.text = presetingMonth.convertToString(withFormat: "MMMM")
            arrayOfDays = getDaysOfMonth(for: presetingMonth)
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presetingMonth = Date()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        
        presetingMonth = Calendar.current.date(byAdding: .month, value: 1, to: presetingMonth)!
    }
    
    @IBAction func lastMonth(_ sender: UIButton) {
        
        presetingMonth = Calendar.current.date(byAdding: .month, value: -1, to: presetingMonth)!
    }
    
    @IBAction func dismissCalendar(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Collection View Delegate & Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return arrayOfDays.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarDayCell", for: indexPath) as! dayCell
        cell.titleLabel.frame = CGRect(x: 0.0, y: 0.0, width: cell.frame.width, height: cell.frame.height)
        
        for index in indexPath{
            
            cell.titleLabel.text = String(arrayOfDays[index])
            
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: indexPath.item + 1)
    }
    
    func getDaysOfMonth(for date:Date) -> [Int]{
        let calendar = Calendar.current
        let date = date
    
        // Calculate start and end of the current year (or month with `.month`):
        let interval = calendar.dateInterval(of: .month, for: date)! //change year it will no of days in a year , change it to month it will give no of days in a current month
    
        // Compute difference in days:
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        return Array(1...days)
    }
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! eventMenuViewController
        let day = String(describing: sender!)
        print("day: ", day)
        let yearAndMonth = presetingMonth.convertToString(withFormat: "yyyy-MM-")
        let date = getDateFromString(string: yearAndMonth + day)
        destVC.reloadInitialPagesForDate(date!)
    }
    
    func getDateFromString(string: String) -> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-d"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = dateFormatter.date(from: string) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        print(date)
        return date
    }
}

