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
    
    var events = Array<Any>(){
        didSet{
            delegate?.didLoadEvents()
            print("done")
        }
    }
    
    init(){
        self.fetchAllEvents()
    }
    
    func refreshEvents(){
        self.fetchAllEvents()
    }

    private func fetchAllEvents(){
        
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
                            
                            var fetchedEvents = Array<Any>()
                            let arrayOfDataOfAllEvents = result["data"] as! Array<Any>
                            for dataOfEvent in arrayOfDataOfAllEvents{
                                if let dict = dataOfEvent as? NSDictionary{
                                    let event = Event(with: dict)
                                    fetchedEvents.append(event)
                            }
                    }
                            self.events = fetchedEvents
                }
            }
        }
    }
}

