//
//  AnnotationDetailViewController.swift
//  PizzaHistoryMap
//
//  Created by Mitya Kim on 10/14/22.
//  Copyright © 2022 Dmitrii Kim. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AnnotationDetailViewController: UIViewController {
    
    var annotation:PizzaAnnotation!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pizzaPhoto: UIImageView!
    @IBOutlet weak var historyText: UITextView!
    
    @IBAction func done(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = annotation.title
        pizzaPhoto.image = annotation.pizzaPhoto
        historyText.text = annotation.historyText
        
        placemark(annotation: annotation) { placemark in
            if let placemark = placemark {
                var locationString = ""
                if let city = placemark.locality {
                    locationString += city + " "
                }
                if let state = placemark.administrativeArea {
                    locationString += state + " "
                }
                if let country = placemark.country {
                    locationString += country
                }
                
                self.historyText.text = locationString + "\n\n" +  self.annotation.historyText
            } else {
                print("Not found")
            }
        }
    }

    func placemark(annotation: PizzaAnnotation, completion: @escaping (CLPlacemark?) -> Void) {
        let coordinate = annotation.coordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let goecoder = CLGeocoder()
        goecoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemarks = placemarks {
                completion(placemarks.first)
            } else {
                completion(nil)
            }
        }
    }

}
