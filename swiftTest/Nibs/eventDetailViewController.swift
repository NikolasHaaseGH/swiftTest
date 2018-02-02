//
//  eventDetailViewController.swift
//  swiftTest
//
//  Created by Nikolas Haase on 31.01.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import UIKit

class eventDetailViewController: UIViewController {

    var eventNameString: String!
    @IBOutlet private weak var eventNameLabel: UILabel!
    var eventImageLink: String!
    @IBOutlet weak var eventImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventNameLabel.text = eventNameString
        eventImageView.downloadedFrom(link: eventImageLink)
        
        eventImageView.layer.masksToBounds = true
        eventImageView.contentMode = .scaleAspectFill
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
