//
//  ViewController.swift
//  PizzaHistoryMap
//
//  Created by Mitya Kim on 10/14/22.
//  Copyright © 2022 Dmitrii Kim. All rights reserved.
//

/* --- Coordinate information -----
            Lat,long                      
 Naples: 40.8367321,14.2468856
 New York: 40.7216294 , -73.995453
 Chicago: 41.892479 , -87.6267592          
 Chatham: 42.4056555,-82.1860369         
 Beverly Hills: 34.0674607,-118.3977309
 
 -->Challenges!!<----
 208 S. Beverly Drive Beverly Hills CA:34.0647691,-118.3991328
 2121 N. Clark St Chicago IL: 41.9206921,-87.6375361
 
 For region monitoring:
 latitude: 37.33454235, longitude: -122.03666775000001
 --- */



import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Properties
    var coordinate2D = CLLocationCoordinate2DMake(40.8367321, 14.2468856)
    var camera = MKMapCamera()
    var pitch = 0
    var isOn = false
    
    //MARK: Outlets
    @IBOutlet weak var changeMapType: UIButton!
    @IBOutlet weak var changePitch: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.addAnnotations(PizzaHistoryAnnotations().annotations)
        updateMapRegion(rangeSpan: 100)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func changeMapType(_ sender: UIButton) {
        switch mapView.mapType {
        case .standard:
            mapView.mapType = .satellite
        case .satellite:
            mapView.mapType = .hybrid
        case .hybrid:
            mapView.mapType = .satelliteFlyover
        case .satelliteFlyover:
            mapView.mapType = .hybridFlyover
        case .hybridFlyover:
            mapView.mapType = .standard
        default:
            break
        }
    }
    
    @IBAction func changePitch(_ sender: UIButton) {
        pitch = (pitch + 15) % 90
        sender.setTitle("\(pitch)º", for: .normal)
        mapView.camera.pitch = CGFloat(pitch)
    }
    
    @IBAction func toggleMapFeatures(_ sender: UIButton) {
//        mapView.showsBuildings = isOn
//        isOn = !isOn
        isOn = !mapView.showsPointsOfInterest
        mapView.showsPointsOfInterest = isOn
        mapView.showsScale = isOn
        mapView.showsCompass = isOn
        mapView.showsTraffic = isOn
    }
    
    @IBAction func findHere(_ sender: UIButton) {
        
    }
    
    @IBAction func findPizza(_ sender: UIButton) {
        
    }

    @IBAction func locationPicker(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        
//        mapView.removeAnnotations(mapView.annotations)
        
        switch index {
        case 0://Naples
            coordinate2D = CLLocationCoordinate2DMake(40.8367321, 14.2468856)
        case 1://New York
            coordinate2D = CLLocationCoordinate2DMake(40.7216294 , -73.995453)
            updateMapCamera(heading: 245.0, altitude: 500)
            
//            let pin = PizzaAnnotation(coordinate: coordinate2D, title: "New York Pizza", subtitle: "The Best Pizza!")
//
//            mapView.addAnnotation(pin)
            return
        case 2://Chicago
            coordinate2D = CLLocationCoordinate2DMake(41.892479 , -87.6267592)
            updateMapCamera(heading: 12.0, altitude: 50)
            return
        case 3://Chatham
            coordinate2D = CLLocationCoordinate2DMake(42.4056555,-82.1860369)
            updateMapCamera(heading: 180.0, altitude: 500)
            return
        case 4://Beverly Hills
            coordinate2D = CLLocationCoordinate2DMake(34.0674607,-118.3977309)
            
//            let pizzaPin = MKPointAnnotation()
//            pizzaPin.coordinate = coordinate2D
//            pizzaPin.title = "Pizza"
//            pizzaPin.subtitle = "Also California Pizza"
//
//            mapView.addAnnotation(pizzaPin)
        default://Beverly Hills
            coordinate2D = CLLocationCoordinate2DMake(34.0674607,-118.3977309)
        }
        updateMapRegion(rangeSpan: 100)
    }
    
//Naples: 40.8367321,14.2468856
//New York: 40.7216294 , -73.995453
//Chicago: 41.892479 , -87.6267592
//Chatham: 42.4056555,-82.1860369
//Beverly Hills: 34.0674607,-118.3977309
    
    //MARK: - Instance Methods
    func updateMapRegion(rangeSpan: CLLocationDistance) {
        let region = MKCoordinateRegion(center: coordinate2D, latitudinalMeters: rangeSpan, longitudinalMeters: rangeSpan)
        mapView.region = region
    }
    
    func updateMapCamera(heading: CLLocationDirection, altitude: CLLocationDistance) {
        camera.centerCoordinate = coordinate2D
        camera.heading = heading
        camera.altitude = altitude
        camera.pitch = 0.0
        changePitch.setTitle("0º", for: .normal)
        mapView.camera = camera
    }
    
    //MARK: Map setup
    
    //MARK: Annotations
    
    //MARK: Overlays
    
    //MARK: Location
    
    //MARK: Find
    
    //MARK: Directions
    
    

    //MARK: - Delegates
    //MARK: Annotation delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
//        var annotationView = MKPinAnnotationView()
        var annotationView = MKAnnotationView()
        
        
        guard let annotation = annotation as? PizzaAnnotation else { return nil }
        
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.id) {
            annotationView = dequedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.id)
        }
        
//        annotationView.pinTintColor = UIColor.systemPurple
        annotationView.image = UIImage(named: "pizza pin")
        
        
        annotationView.canShowCallout = true
        
        let paragraph = UILabel()
        paragraph.numberOfLines = 1
        paragraph.font = UIFont.preferredFont(forTextStyle: .caption1)
        paragraph.text = annotation.subtitle
        paragraph.adjustsFontSizeToFitWidth = true
        
        annotationView.detailCalloutAccessoryView = paragraph
        
        annotationView.leftCalloutAccessoryView = UIImageView(image: annotation.pizzaPhoto)
        
        annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let vc = AnnotationDetailViewController(nibName: "AnnotationDetailViewController", bundle: nil)
        vc.annotation = view.annotation as? PizzaAnnotation
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: Overlay delegates
    //MARK: Location Manager delegates
    

}

