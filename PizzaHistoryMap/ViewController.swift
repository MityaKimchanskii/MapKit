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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: - Properties
    var coordinate2D = CLLocationCoordinate2DMake(40.8367321, 14.2468856)
    var camera = MKMapCamera()
    var pitch = 0
    var isOn = false
    var locationManager = CLLocationManager()
    
    //MARK: Outlets
    @IBOutlet weak var changeMapType: UIButton!
    @IBOutlet weak var changePitch: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.delegate = self
        
        mapView.addAnnotations(PizzaHistoryAnnotations().annotations)
        
        addDeliveryOverlay()
        addPolylines()
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
        sutupCoreLocation()
    }
    
    @IBAction func findPizza(_ sender: UIButton) {
        
    }

    @IBAction func locationPicker(_ sender: UISegmentedControl) {
        
        disableLocationServices()
        
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
            updateMapCamera(heading: 0.0, altitude: 15000)
            return
        case 3://Chatham
            coordinate2D = CLLocationCoordinate2DMake(42.4056555,-82.1860369)
            updateMapCamera(heading: 180.0, altitude: 500)
            return
        case 4://Beverly Hills
            coordinate2D = CLLocationCoordinate2DMake(34.0674607,-118.3977309)
            
            let pizzaPin = MKPointAnnotation()
            pizzaPin.coordinate = coordinate2D
            pizzaPin.title = "Pizza"
            pizzaPin.subtitle = "Also California Pizza"
//
//            mapView.addAnnotation(pizzaPin)
            updateMapCamera(heading: 0, altitude: 1500)
            return
            
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
    func addPolylines() {
        let annotations = PizzaHistoryAnnotations().annotations
        let beverlyHills = annotations[5].coordinate
        let beverlyHills2 = annotations[6].coordinate
        let bhPolyline = MKPolyline(coordinates: [beverlyHills, beverlyHills2], count: 2)
        bhPolyline.title = "Beverly_Line"
        
        var coordinates = [CLLocationCoordinate2D]()
        for location in annotations {
            coordinates.append(location.coordinate)
        }
        
        let grandTour = MKPolyline(coordinates: coordinates, count: coordinates.count)
        grandTour.title = "GrandTour_Line"
        
        mapView.addOverlays([grandTour ,bhPolyline])
    }
    
    func addDeliveryOverlay() {
//        let radius = 1600.0
        for location in mapView.annotations {
            if let radius = (location as! PizzaAnnotation).deliveryRadius {
                let circle = MKCircle(center: location.coordinate, radius: radius)
                mapView.addOverlay(circle)
            }
//            let circle = MKCircle(center: location.coordinate, radius: radius)
//            mapView.addOverlay(circle)
        }
    }
    
    //MARK: Location
    func sutupCoreLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            enabledLocationServices()
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        @unknown default:
            break
        }
        
    }
    
    func enabledLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            mapView.setUserTrackingMode(.follow, animated: true)
        }
    }
    
    func disableLocationServices() {
        locationManager.stopUpdatingLocation()
    }
    
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
        
        if annotation.pizzaPhoto == nil {
            annotation.pizzaPhoto = UIImage(named: "pizza pin")
        }
        
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
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let polyline = overlay as? MKPolyline {
            let polylineRenderer = MKPolylineRenderer(polyline: polyline)
            
            if polyline.title == "GrandTour_Line" {
                polylineRenderer.strokeColor = UIColor.red
                polylineRenderer.lineWidth = 5.0
                return polylineRenderer
            }
            
            polylineRenderer.strokeColor = UIColor.green
            polylineRenderer.lineWidth = 3.0
            polylineRenderer.lineDashPattern = [20, 10, 2, 10]
            return polylineRenderer
        }
        
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.fillColor = UIColor(red: 0.0, green: 0.1, blue: 1.0, alpha: 0.1)
            circleRenderer.strokeColor = UIColor.blue
            circleRenderer.lineWidth = 1.0
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    //MARK: Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("Ok")
        case .denied, .restricted:
            print("No")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        coordinate2D = location.coordinate
        let displayString = "\(location.timestamp) Coord:\(coordinate2D) Alt: \(location.altitude) meters"
//        print(displayString)
        
        updateMapRegion(rangeSpan: 200)
        
        let pin = PizzaAnnotation(coordinate: coordinate2D, title: displayString, subtitle: "")
        mapView.addAnnotation(pin)
    }
}

