//
//  eventTVCell.swift
//  swiftTest
//
//  Created by Nikolas Haase on 24.01.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import UIKit

class eventTVCell: UITableViewCell {

    @IBOutlet private weak var eventNameLabel: UILabel!
    var eventNameString: String!
    @IBOutlet private weak var placeNameLabel: UILabel!
    var placeNameString: String!
    @IBOutlet private weak var timeLabel: UILabel!
    var timeString: String!
    @IBOutlet private weak var locationLabel: UILabel!
    var locationString: String!
    @IBOutlet private weak var statusButton: UIButton!
    var statusString: String!
    @IBOutlet private weak var backgroundImg: UIImageView!
    var backgroundImgLink: String!
    @IBOutlet private weak var detailBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor().getRandomColor()
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        detailBackgroundView.layer.cornerRadius = self.layer.cornerRadius
        detailBackgroundView.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        eventNameLabel.text = eventNameString
        placeNameLabel.text = placeNameString
        timeLabel.text = timeString
        locationLabel.text = locationString
        backgroundImg.downloadedFrom(link: backgroundImgLink)
        
        backgroundImg.layer.masksToBounds = true
        backgroundImg.contentMode = .scaleAspectFill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIColor{
    
    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
