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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate
{
    
    var mapView = MKMapView()
    var stories = [Story]()
    var locationManager = CLLocationManager()
    var searchController:UISearchController!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var chosenStory:Story!
    var isLiked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderDistance:CGFloat = ((self.view.frame.height/7)/8)*2
        
        let buttomSize:CGFloat = borderDistance * 3;
        let buttomBHeight = self.view.frame.height - buttomSize
        let buttomRWidht = self.view.frame.width - buttomSize
        
        
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
        
        var voltarButton = UIButton()
        var localizationButton = UIButton()
        var mapTypeButton = UIButton()
        
        voltarButton.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        voltarButton.addTarget(self, action: "voltarButtonPressed", forControlEvents: .TouchUpInside)
        
        localizationButton.setImage(UIImage(named: "localization"), forState: UIControlState.Normal)
        localizationButton.addTarget(self, action: "localizationButtonPressed", forControlEvents: .TouchUpInside)
        
        mapTypeButton.setImage(UIImage(named: "Map"), forState: UIControlState.Normal)
        mapTypeButton.addTarget(self, action: "mapTypeButtonPressed", forControlEvents: .TouchUpInside)
        
        if( UIDevice.currentDevice().userInterfaceIdiom == .Pad )
        {
            voltarButton.frame = CGRectMake(self.view.frame.size.width/530, self.view.frame.height/1.1, buttomSize, buttomSize)
            
            localizationButton.frame = CGRectMake(  self.view.frame.width/1.15,
                self.view.frame.height/1.1,
                buttomSize, buttomSize)
            
            mapTypeButton.frame = CGRectMake(   self.view.frame.width/1.13,
                self.view.frame.size.height/100,
                buttomSize*0.75, buttomSize*0.75)

        }
        else
        {
            voltarButton.frame = CGRectMake(self.view.frame.size.width/200, self.view.frame.height/1.12, buttomSize, buttomSize)
            
            localizationButton.frame = CGRectMake(  self.view.frame.width/1.27,
                                                    self.view.frame.height/1.12,
                                                    buttomSize, buttomSize)
            
            mapTypeButton.frame = CGRectMake(   self.view.frame.width/1.2,
                                                borderDistance,
                                                buttomSize*0.75, buttomSize*0.75)
        }
        
        /* ********************************************* */
        
        mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        mapView.delegate = self
        mapView.showsBuildings = false
        mapView.showsPointsOfInterest = false
        mapView.mapType = MKMapType.Hybrid
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.view.addSubview(mapView)
        self.view.addSubview(topView)
        self.view.addSubview(localizationButton)
        self.view.addSubview(voltarButton)
        self.view.addSubview(mapTypeButton)
        
        addAnnotations()
    }

    override func viewDidAppear(animated: Bool)
    {
        var legalLabel = mapView.subviews[1] as! UILabel
        legalLabel.frame = CGRectMake(self.view.frame.width/2 - legalLabel.frame.width/2, self.view.frame.height - legalLabel.frame.height*2, legalLabel.frame.width, legalLabel.frame.height)
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
    
    func addAnnotations()
    {
        stories = LibraryAPI.sharedInstance.getStories()
        for (var i = 0; i < stories.count; i++)
        {
            var annotation = StoryAnnotation(coordinate:  CLLocationCoordinate2DMake(stories[i].local.latitude, stories[i].local.longitude), title: stories[i].title, story:stories[i])
            mapView.addAnnotation(annotation)
            var gestureRecognizer = UITapGestureRecognizer(target: self, action: "clickedOnStory")
            
        }
        
    }
    
    func mapView(aMapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        if let annotation = annotation as? StoryAnnotation
        {
            let identifier = "test"
            var heartPin:MKAnnotationView
            if let dequeudView = aMapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            {
                dequeudView.annotation = annotation
                heartPin = dequeudView
            }
            else
            {
                heartPin = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                heartPin.canShowCallout = true
                heartPin.calloutOffset = CGPointMake(0, 4.9)
                
            }
            
            
            var readButton = UIButton()
            readButton.frame.size.height = 30
            readButton.frame.size.width = 30
            readButton.setImage(UIImage(named:"Read.png"), forState: UIControlState.allZeros)
            heartPin.rightCalloutAccessoryView = readButton
            
            switch(annotation.story.type){
                case "0":
                    println("0")
                    heartPin.image = UIImage(named: "MapPin")
                    break
                case "1":
                    println("1")
                    heartPin.image = UIImage(named: "FunnyPin")
                    break
                case "2":
                    println("2")
                    heartPin.image = UIImage(named: "OvercomePin")
                    break
                case "3":
                    println("3")
                    heartPin.image = UIImage(named: "GenericPin")
                    break
            default:
                    break
            }
            return heartPin
        }
        
        return nil
    }

    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if let annotation = view.annotation as? StoryAnnotation {
            
            if (control == view.rightCalloutAccessoryView) {
                chosenStory = annotation.story
                performSegueWithIdentifier("singleStoryView", sender: nil)
            }

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "singleStoryView"){
            var svc = segue.destinationViewController as! SingleStoryViewController;
            
            svc.currentStory = chosenStory
        
        }
    }
    /* *********************************************
    Métodos do CLLocation */
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
            mapView.showsUserLocation = true
            
            if let location = locationManager.location?.coordinate {
                
                mapView.setCenterCoordinate(location, animated: true)
                
                let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                
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
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
    func mapTypeButtonPressed(){
        
        if(mapView.mapType == MKMapType.Hybrid){
            mapView.mapType = MKMapType.Standard
            
        }else{
            mapView.mapType = MKMapType.Hybrid
        }
    }
    /* ********************************************* */
    
    @IBAction func voltarButtonPressed() {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
