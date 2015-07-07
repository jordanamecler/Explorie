//
//  StoryAnnotation.swift
//  Explorie
//
//  Created by Lorenzo Saraiva on 5/31/15.
//  Copyright (c) 2015 Explories. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation
import MapKit



class StoryAnnotation : NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var title: String
    var story: Story
    var likeButton = UIButton()
    
    init(coordinate: CLLocationCoordinate2D, title: String, story: Story)
    {
        self.coordinate = coordinate
        self.title = title
        self.story = story
    }
}
