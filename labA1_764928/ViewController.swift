//
//  ViewController.swift
//  labA1_764928
//
//  Created by MacStudent on 2020-01-14.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var findMyWay: UIButton!
    
    var locationManager = CLLocationManager()
    var s : CLLocationCoordinate2D?
    var d: CLLocationCoordinate2D?
    var coordinate: CLLocationCoordinate2D?
    var drive = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.64, longitude: -79.38) , span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTapGesture)
    }

    @IBAction func zoomIn(_ sender: UIButton) {
      var zoom = mapView.region
        zoom.span.latitudeDelta = zoom.span.latitudeDelta*2
        zoom.span.longitudeDelta = zoom.span.longitudeDelta*2
        mapView.setRegion(zoom, animated: true)
    }
    
    @IBAction func zoomOut(_ sender: UIButton) {
        
        var zoom = mapView.region
               zoom.span.latitudeDelta = zoom.span.latitudeDelta/2
               zoom.span.longitudeDelta = zoom .span.longitudeDelta/2
               mapView.setRegion(zoom, animated: true)
        
    }
    @IBAction func walkingDistance(_ sender: UIButton) {
        
        drive = false
        let overlay = mapView.overlays
        if overlay.count > 0
        {
            mapView.removeOverlays(overlay)
        }
      path()
    }
    @IBAction func carDistance(_ sender: UIButton) {
       drive = true
        let overlay = mapView.overlays
        if overlay.count > 0 {
            mapView.removeOverlays(overlay)
        }
        path()
    }
    @objc func doubleTapped(gestureRecognizer: UIGestureRecognizer) {
       
        
        let allAnotation = mapView.annotations
        
        if allAnotation.count > 1{
            
            let ar = allAnotation[1]
            mapView.removeAnnotation(ar)
        }
        
        let overlay = mapView.overlays
        if overlay.count > 0 {
            mapView.removeOverlays(overlay)
        }
    
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
       
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
       
        d = coordinate
        //count += 1
       print("annotation")
        
    }
    
    
    
        
    @IBAction func findMyWayBtn(_ sender: UIButton) {
        
       path()
            
                    
        }
    
    func path(){
        let source = mapView.annotations[0].coordinate
                 
                   let sourcePlacemark = MKPlacemark(coordinate: source)
                   let destinationMark = MKPlacemark(coordinate: d!)
               
               let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
               let destinationMapITem = MKMapItem(placemark: destinationMark)
                                    
               
               let request = MKDirections.Request()
               request.source = sourceMapItem
               request.destination = destinationMapITem
               //request.requestsAlternateRoutes = true
        request.transportType = drive ? MKDirectionsTransportType.automobile : MKDirectionsTransportType.walking
                       print("request")
                                    
               let directions = MKDirections(request: request)
                          
                       directions.calculate { (response, error )in
                               guard let unwrappedResponse = response else {
                                   if let e = error {
                                       print("error")
                                   }
                                      return
                               }
                           print("response")
                           let route = unwrappedResponse.routes[0]
                           self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)}
        
    }
    
                           func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                            print("renderer")
                            
                            if overlay is MKPolyline{
                                
                            let renderer = MKPolylineRenderer(overlay: overlay)
                            renderer.strokeColor = UIColor.blue
                           
                                     return renderer
                                 }
                        
            return MKOverlayRenderer()
        
    }
    
}
    
    




