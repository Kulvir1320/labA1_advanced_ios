//
//  ViewController.swift
//  labA1_764928
//
//  Created by MacStudent on 2020-01-14.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var findMyWay: UIButton!
    
    var locationManager = CLLocationManager()
    var s : CLLocationCoordinate2D?
    var d: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTapGesture)
    }

    @objc func doubleTapped(gestureRecognizer: UIGestureRecognizer) {
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
       
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        s = mapView.annotations[0].coordinate
        d = mapView.annotations[1].coordinate
        
        
        let request = MKDirections.Request()
              request.source = MKMapItem(placemark: MKPlacemark(coordinate: s!, addressDictionary: nil))
              request.destination = MKMapItem(placemark: MKPlacemark(coordinate: d!, addressDictionary: nil))
              
              request.requestsAlternateRoutes = true
              request.transportType = .automobile
              
              let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }

                for route in unwrappedResponse.routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
           
            func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                      let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
                      renderer.strokeColor = UIColor.blue
                      return renderer
                  }
         
        }
    }
        
      
    }


//        func findMyWayBtn(_ sender: UIButton) {
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: s!, addressDictionary: nil))
//        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: d!, addressDictionary: nil))
//
//        request.requestsAlternateRoutes = true
//        request.transportType = .automobile
//
//        let directions = MKDirections(request: request)
//
////        let request = MKDirections.Request()
////        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059), addressDictionary: nil))
////        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667), addressDictionary: nil))
////        request.requestsAlternateRoutes = true
////        request.transportType = .automobile
////
////        let directions = MKDirections(request: request)
////
//        directions.calculate { [unowned self] response, error in
//            guard let unwrappedResponse = response else { return }
//
//            for route in unwrappedResponse.routes {
//                self.mapView.addOverlay(route.polyline)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//            }
//        }
//    }
   


