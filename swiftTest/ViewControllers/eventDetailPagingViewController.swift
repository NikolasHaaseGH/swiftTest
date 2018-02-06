//
//  eventDetailPagingViewController.swift
//  swiftTest
//
//  Created by Nikolas Haase on 02.02.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import UIKit

class eventDetailPagingViewController: UIViewController{

    var representingEvents = [Event]()
    private var pages = [eventDetailViewController]()
    private var pageToPresent: Int!
    private var currentPage: Int!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(representingEvents.count), height: scrollView.frame.height)

        for index in 0..<representingEvents.count{
            let event = representingEvents[index]
            
            let newVC = eventDetailViewController(nibName: "eventDetailViewController", bundle: nil)
            newVC.eventImageLink = EventList.getLinkOfImgForID(event.thumbnailID!, resolution: .normal)
            newVC.eventName = event.name
            let frame = scrollView.frame
            newVC.view.frame = CGRect(x: frame.width * CGFloat(index), y: 0.0, width: frame.width, height: frame.height)
            scrollView.addSubview(newVC.view)
            pages.append(newVC)
        }
    }

    @IBAction func dismissViewController(_ sender: UIButton) {
            self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
