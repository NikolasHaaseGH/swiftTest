//
//  Event.swift
//  swiftTest
//
//  Created by Nikolas Haase on 23.01.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import Foundation
import CoreLocation

struct Event{
    let id: String, name: String, description: String?, location: Location?, startTime: Date?, endTime: Date?, userStatus: String?
    
    init(with Dict: NSDictionary){
        id = Dict.value(forKey: "id") as! String
        name = Dict.value(forKey: "name") as! String
        description = Dict.value(forKey: "description") as? String
        location = Location(with: Dict)
        startTime = (Dict.value(forKey: "start_time") as? String)?.toDate
        endTime = (Dict.value(forKey: "end_time") as? String)?.toDate
        userStatus = Dict.value(forKey: "rsvp_status") as? String
    }
    
    struct Location{
        
        var coordinates: CLLocationCoordinate2D{
            get{ return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!) }
        }
        
        let name: String?, city: String?, country: String?, latitude: Double?, longitude: Double?, street: String?, zip: String?
        init(with Dict: NSDictionary){
            name = ""
            
            let locationDict = ((Dict["place"] as? NSDictionary)?.value(forKey: "location") as? NSDictionary)
            city = locationDict?.value(forKey: "city") as? String
            country = locationDict?.value(forKey: "country") as? String
            latitude = locationDict?.value(forKey: "latitude") as? Double
            longitude = locationDict?.value(forKey: "longitude") as? Double
            street = locationDict?.value(forKey: "street") as? String
            zip = locationDict?.value(forKey: "zip") as? String
        }
    }
}

extension String{
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        guard let date = dateFormatter.date(from: self) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        return date
    }
}
