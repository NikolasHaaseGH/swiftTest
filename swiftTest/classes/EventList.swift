//
//  EventList.swift
//  swiftTest
//
//  Created by Nikolas Haase on 19.01.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin


protocol EventListDelegate {
    
    func didLoadEvents()
}

class EventList{
   
    var delegate : EventListDelegate?
    
    init(){
        refreshEvents()
    }

    fileprivate var eventsAtDates: [String : [Event]]!{
        didSet{
            delegate?.didLoadEvents()
        }
    }
    
    
    //EVENTS & SORTING //
    func distinct<T: Equatable>(_ array: [T]) -> [T]{
        var unique = [T]()
        array.forEach(){ item in
        !unique.contains(item) ? unique.append(item) : nil
        }
        print(unique)
        return unique
    }
    
    fileprivate func sortEvents(_ events: [Event]) -> [String : [Event]]{
        
        let dates = events.map{ $0.startTime!.convertToString(withFormat: "dMMMyyy") }
        
        return Dictionary(uniqueKeysWithValues: distinct(dates).map{ (times) -> (String, [Event]) in
            (times, events.filter{ (event) -> Bool in
                event.startTime?.convertToString(withFormat: "dMMMyyy") == times
            })
        })
    }
    
    func refreshEvents(){
        fetchEventsJSONFromFacebook()
    }
    
    func eventsForDate(date: Date) -> [Event]? {
        let formattedDateString = date.convertToString(withFormat: "dMMMyyy")
        return eventsAtDates[formattedDateString]
    }
    
    
    
    // FACEBOOK EVENTS //
    private func createEventsFromFacebook(_ result: [String : Any]){
        
        var fetchedEvents = [Event]()
        let arrayOfPages = result["data"] as! Array<Any>
        let arrayOfEvents = arrayOfPages.flatMap{(($0 as! NSDictionary).value(forKey: "events") as! NSDictionary).value(forKey: "data") as! Array<Any>}
        var arrayOfEventIDs = [String]()
        
        for dataOfEvent in arrayOfEvents{
            if let dict = dataOfEvent as? NSDictionary{
                let event = Event(with: dict)
                if !arrayOfEventIDs.contains(event.id){
                    fetchedEvents.append(event)
                    arrayOfEventIDs.append(event.id)
                }
            }
        }
        eventsAtDates = sortEvents(fetchedEvents)
    }
    
    fileprivate func fetchEventsJSONFromFacebook(){
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
                            self.createEventsFromFacebook(result)
                        }
            }
        }
        
        let connection = GraphRequestConnection()
        let request = fbGraphRequest(graphPath: "/me/event", parameters: "", accessToken: AccessToken.current!, httpMethod: GraphRequestHTTPMethod.GET)
        connection.add(request) { response, result in
            switch result {
            case .success(let response):
                print("My facebook id is \(String(describing: response.dictionaryValue))")
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
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

fileprivate struct fbGraphRequest: GraphRequestProtocol {
    
    fileprivate struct Response: GraphResponseProtocol {
        fileprivate let rawResponse: Any?
        
        public init(rawResponse: Any?) {
            self.rawResponse = rawResponse
        }
        
        public var dictionaryValue: [String : Any]? {
            return rawResponse as? [String : Any]
        }
    }
    
    let graphPath: String
    let parameters: [String : Any]?
    let accessToken: AccessToken?
    let httpMethod: GraphRequestHTTPMethod
    let apiVersion: GraphAPIVersion = .defaultVersion
    
    init(graphPath: String, parameters: Any, accessToken: AccessToken, httpMethod: GraphRequestHTTPMethod) {
        
        self.graphPath = graphPath
        self.parameters = ["fields" : parameters]
        self.accessToken = accessToken
        self.httpMethod = httpMethod
    }
    
   
}

