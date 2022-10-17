//
//  PizzaAnnotation.swift
//  PizzaHistoryMap
//
//  Created by Mitya Kim on 10/14/22.
//  Copyright © 2022 Dmitrii Kim. All rights reserved.
//

import UIKit
import MapKit

class PizzaAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var id = "Pin"
    var historyText = ""
    var pizzaPhoto: UIImage? = nil
    var deliveryRadius: CLLocationDistance? = nil
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
