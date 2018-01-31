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
        
        let params = ["fields" : ""]
        let graphRequest = GraphRequest(graphPath: "me/events", parameters: params)
                graphRequest.start {
                    (urlResponse, requestResult) in
                    
                    switch requestResult {
                    case .failed(let error):
                        print("error in graph request:", error)
                        break
                    case .success(let graphResponse):
                        if let result = graphResponse.dictionaryValue {
                            
                            var fetchedEvents = [String : [Event]]()
                            let arrayOfDataOfAllEvents = result["data"] as! Array<Any>
                            for dataOfEvent in arrayOfDataOfAllEvents{
                                if let dict = dataOfEvent as? NSDictionary{
                                    let event = Event(with: dict)
                                    print(event)
                                    let stringDate = event.startTime?.convertToString(withFormat: "d MMM")
                                    
                                    var array = [Event]()
                                    if let val = fetchedEvents[stringDate!] {
                                        array = val
                                    }
                                    array.append(event)
                                    fetchedEvents[stringDate!] = array
                            }
                    }
                            self.dictOfEventsAtDates = fetchedEvents
                }
            }
        }
    }
}


