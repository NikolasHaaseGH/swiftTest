//
//  EventList.swift
//  swiftTest
//
//  Created by Nikolas Haase on 19.01.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import Foundation
import FacebookCore


protocol EventListDelegate {
    
    func didLoadEvents()
}

class EventList{
    
    var delegate : EventListDelegate?
    
    fileprivate var facebookJSON: String!
    
    fileprivate var dictOfEventsAtDates = [String : [Event]](){
        didSet{
            delegate?.didLoadEvents()
        }
    }
    
    init(){
        refreshEvents()
    }

    func eventsForDate(date: Date) -> [Event]? {
        let formattedDateString = date.convertToString(withFormat: "d MMM")
        return dictOfEventsAtDates[formattedDateString]
    }
    
    func refreshEvents(){
        fetchAllEvents()
    }

    fileprivate func fetchAllEvents(){
        let params = ["fields" : "events{end_time, start_time, id, name, rsvp_status, place, cover}"]
        let graphRequest = GraphRequest(graphPath: "me/likes", parameters: params)
                graphRequest.start {
                    (urlResponse, requestResult) in
                    
                    switch requestResult {
                    case .failed(let error):
                        print("error in graph request:", error)
                        break
                    case .success(let graphResponse):
                        if let result = graphResponse.dictionaryValue {
                            var fetchedEvents = [String : [Event]]()
                            let arrayOfPages = result["data"] as! Array<Any>
                            let arrayOfEvents = arrayOfPages.flatMap{(($0 as! NSDictionary).value(forKey: "events") as! NSDictionary).value(forKey: "data") as! Array<Any>}
                            var arrayOfEventIDs = [String]()
                            print(arrayOfEvents)
                            
                            for dataOfEvent in arrayOfEvents{
                                if let dict = dataOfEvent as? NSDictionary{
                                    let event = Event(with: dict)
                                    let stringDate = event.startTime?.convertToString(withFormat: "d MMM")
                                    let stringID = dict.value(forKey: "id") as! String
                                    
                                    if !arrayOfEventIDs.contains(stringID){
                                        arrayOfEventIDs.append(stringID)
                                        
                                        var array = [Event]()
                                        if let val = fetchedEvents[stringDate!] { array = val }
                                        array.append(event)
                                        fetchedEvents[stringDate!] = array
                                        }
                                }
                            }
                            self.dictOfEventsAtDates = fetchedEvents
                }
            }
        }
    }
    
    enum Resolution: String{
        case large = "large"
        case normal = "normal"
        case small = "small"
        case thumbnail = "thumbnail"
        case album = "album"
    }
    
    static func getLinkOfImgForID(_ id: String, resolution: Resolution) -> String{
        return "https://graph.facebook.com/\(id)/picture?type=\(resolution.rawValue)"
    }
}


