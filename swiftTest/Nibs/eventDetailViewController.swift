//
//  eventDetailViewController.swift
//  swiftTest
//
//  Created by Nikolas Haase on 02.02.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import UIKit

class eventDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var eventName: String!
    @IBOutlet weak var eventNameLabel: UILabel!
    var eventImageLink: String!
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var imageContentView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var eventNameBackground: UIView!
    
    @IBOutlet weak var imageToTopViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageToScrollViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("new View")
        contentView.layer.cornerRadius = 5.0
        contentView.clipsToBounds = true
        imageContentView.layer.cornerRadius = 5.0
        
        eventImageView.downloadedFrom(link: eventImageLink)
        eventImageView.contentMode = .scaleAspectFill
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - ScrollView///////////////
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        print(offsetY)
        if offsetY <= eventImageView.frame.height{
            imageToScrollViewConstraint.constant = -offsetY
            eventImageView.alpha = 1 - (offsetY/200)
            //imageToTopViewConstraint.constant = offsetY/5 + 5.0
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
