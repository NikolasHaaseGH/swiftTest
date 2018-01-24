//
//  mapViewController.swift
//  swiftTest
//
//  Created by Nikolas Haase on 16.01.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import UIKit
import FacebookCore
import Mapbox

class mapViewController: UIViewController, MGLMapViewDelegate{

    var mapView: MGLMapView!
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "mapbox://styles/mapbox/streets-v9")
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        //let eventList = EventList()
        //print(EventList.eventIDs)
 
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
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

extension MGLPointAnnotation{
    
     var event: Event{
        set{}
        get{
            return self.event
        }
    }
    
    convenience init(with event: Event){
        self.init()
        self.event = event
        self.coordinate = CLLocationCoordinate2D(latitude: (event.location?.latitude)!, longitude: (event.location?.longitude)!)
        self.title = event.name
        self.subtitle = (event.location?.name)!
    }
}

