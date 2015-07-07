//
//  MapViewController.swift
//  Explorie
//
//  Created by Jordana Mecler on 21/05/15.
//  Copyright (c) 2015 Explories. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation

class ChoseLocalViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    var searchController:UISearchController!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderDistance:CGFloat = ((self.view.frame.height/7)/8)*2
        let buttomSize:CGFloat = borderDistance * 3;
        
        var topView = UIView()
        topView.backgroundColor = UIColor.clearColor()
        
        var border = CAShapeLayer();
        border.frame = self.view.frame
        border.path = createBorder( borderDistance )
        border.strokeColor = UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0).CGColor
        border.fillColor = UIColor(red: 255/255, green: 219/255, blue: 180/255, alpha: 1.0).CGColor
        border.lineWidth = 2.0
        topView.layer.addSublayer(border)
        
        /* *********************************************
        Declaração dos botões */
        
        var localizationButton = UIButton()
        localizationButton.setImage(UIImage(named: "localization"), forState: UIControlState.Normal)
        localizationButton.addTarget(self, action: "localizationButtonPressed", forControlEvents: .TouchUpInside)
        
        var voltarButton = UIButton()
        voltarButton.layer.cornerRadius = 20
        voltarButton.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        voltarButton.addTarget(self, action: "voltarButtonPressed", forControlEvents: .TouchUpInside)
        
        if( UIDevice.currentDevice().userInterfaceIdiom == .Pad )
        {
            voltarButton.frame = CGRectMake(self.view.frame.size.width/530, self.view.frame.height/1.1, buttomSize, buttomSize)
            localizationButton.frame = CGRectMake(  self.view.frame.width/1.15, self.view.frame.height/1.1, buttomSize, buttomSize)
        }
        else
        {
            voltarButton.frame = CGRectMake(self.view.frame.size.width/200, self.view.frame.height/1.12, buttomSize, buttomSize)
            localizationButton.frame = CGRectMake(  self.view.frame.width/1.27, self.view.frame.height/1.12, buttomSize, buttomSize)
        }
        
        /* ********************************************* */
        
        mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        mapView.delegate = self
        mapView.showsBuildings = false
        mapView.showsPointsOfInterest = false
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "localTap:")
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        self.view.addSubview(mapView)
        self.view.addSubview(topView)
        self.view.addSubview(voltarButton)
        self.view.addSubview(localizationButton)
        self.view.sendSubviewToBack(mapView)

    }
    
    override func viewDidAppear(animated: Bool) {
    
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
    func createBorder( borderDistance : CGFloat ) -> CGPath
    {
        var path = CGPathCreateMutable()
        var cornerRadius:CGFloat = 60.0
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        CGPathMoveToPoint(path, nil, -1.0, borderDistance + cornerRadius)
        CGPathAddLineToPoint(path, nil, borderDistance, borderDistance + cornerRadius)
        CGPathAddArc(path, nil, borderDistance, borderDistance, cornerRadius, CGFloat(M_PI)/2, 0.0, true)
        CGPathAddLineToPoint(path, nil, width - cornerRadius - borderDistance, borderDistance)
        CGPathAddArc(path, nil, width - borderDistance, borderDistance, cornerRadius, CGFloat(M_PI), CGFloat(M_PI)/2, true)
        CGPathAddLineToPoint(path, nil, width + 1, borderDistance + cornerRadius)
        CGPathAddLineToPoint(path, nil, width + 1, -1.0)
        CGPathAddLineToPoint(path, nil, -1.0, -1.0)
        CGPathAddLineToPoint(path, nil, -1.0, borderDistance + cornerRadius)
        
        CGPathMoveToPoint(path, nil, -1.0, height - borderDistance - cornerRadius)
        CGPathAddLineToPoint(path, nil, borderDistance, height - borderDistance - cornerRadius)
        CGPathAddArc(path, nil, borderDistance, height - borderDistance, cornerRadius, -CGFloat(M_PI)/2, 0.0, false)
        CGPathAddLineToPoint(path, nil, borderDistance + cornerRadius, height + 1.0)
        CGPathAddLineToPoint(path, nil, width - cornerRadius - borderDistance, height + 1.0)
        CGPathAddLineToPoint(path, nil, width - cornerRadius - borderDistance, height - borderDistance)
        CGPathAddArc(path, nil, width - borderDistance, height - borderDistance, cornerRadius, CGFloat(M_PI), -CGFloat(M_PI)/2, false)
        CGPathAddLineToPoint(path, nil, width + 1.0, height - borderDistance - cornerRadius)
        CGPathAddLineToPoint(path, nil, width + 1.0, height + 1.0)
        CGPathAddLineToPoint(path, nil, -1.0, height + 1.0)
        CGPathAddLineToPoint(path, nil, -1.0, height - borderDistance - cornerRadius)
        
        return path
    }
    
    /* *********************************************
    Métodos do CLLocation */
    
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
            mapView.showsUserLocation = true
            
            if let location = locationManager.location?.coordinate {
                
                mapView.setCenterCoordinate(location, animated: true)
                
                let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                
                self.mapView.setRegion(region, animated: true)
                
                
            }
            else {
                locationManager.startUpdatingLocation()
            }
        }
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

        if let location = locations.last as? CLLocation {
            
            mapView.setCenterCoordinate(location.coordinate, animated: true)
            mapView.camera.altitude = pow(2,11)
        }
    }
    
    
    /* ********************************************* */
    
    /* *********************************************
    Métodos do Search Bar */
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler {
            (localSearchResponse, error)->Void in
        }
    }
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    @IBAction func localizationButtonPressed() {
        println("search")
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
    func localTap(recognizer: UITapGestureRecognizer){
        
        var tapPoint = recognizer.locationInView(self.mapView)
        var location = self.mapView.convertPoint(tapPoint, toCoordinateFromView: self.mapView)

        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        let alerta = UIAlertController(title: "Deseja confirmar o local?", message: nil, preferredStyle: .Alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action -> Void in
            
            println(location.longitude)
            println(location.latitude)
            LibraryAPI.sharedInstance.storyLat = location.latitude as Double
            LibraryAPI.sharedInstance.storyLong = location.longitude as Double
        
            self.dismissViewControllerAnimated(true, completion: nil)

        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            self.mapView.removeAnnotation(annotation)
        
        }
        
        alerta.addAction(okAction)
        alerta.addAction(cancelAction)
        
        self.presentViewController(alerta, animated: true, completion: nil)

        
    }
    /* ********************************************* */
    
    @IBAction func voltarButtonPressed() {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
}
