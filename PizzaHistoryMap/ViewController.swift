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

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: - Properties and outlets
    var coordinate2D = CLLocationCoordinate2DMake(40.8367321,14.2468856)
    var camera = MKMapCamera()
    var pitch = 0
    var isOn = false
    var locationManager = CLLocationManager()
    var heading = 0.0
    let onRampCoordinate = CLLocationCoordinate2DMake(37.3346, -122.0345)
    var startMapItem = MKMapItem()
    var destinationMapItem = MKMapItem()
    //MARK: Outlets
    @IBOutlet weak var changeMapType: UIButton!
    @IBOutlet weak var changePitch: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Actions
    @IBAction func changeMapType(_ sender: UIButton) {
        switch mapView.mapType{
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
        case .mutedStandard:
            print("mutedStandard")
        @unknown default:
            print("default")
        }
    }
    
    @IBAction func changePitch(_ sender: UIButton) {
      pitch = (pitch + 15) % 90
      sender.setTitle("\(pitch)º", for: .normal)
        mapView.camera.pitch = CGFloat(pitch)
    }
    @IBAction func toggleMapFeatures(_ sender: UIButton) {
        disableLocationServices()
        //mapView.showsBuildings = isOn
        //isOn = !isOn
        isOn = !mapView.showsPointsOfInterest
        mapView.showsPointsOfInterest = isOn
        mapView.showsScale = isOn
        mapView.showsCompass = isOn
        mapView.showsTraffic = isOn
    }
    
    @IBAction func findHere(_ sender: UIButton) {
        setupCoreLocation()
    }
    
    @IBAction func findPizza(_ sender: UIButton) {
       /*
        let address = "2121 N. Clark St. IL"
        getCoordinate(address: address) { (coordinate, location, error) in
            if let coordinate = coordinate{
                self.mapView.camera.centerCoordinate = coordinate
                self.mapView.camera.altitude = 1000.0
                let pin = PizzaAnnotation(coordinate: coordinate, title: address, subtitle: location)
                self.mapView.addAnnotation(pin)
            }
        }*/
        /* let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Pizza"
        updateMapRegion(rangeSpan: 500)
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error == nil {
                if let response = response{
                    for mapItem in response.mapItems{
                        let placemark = mapItem.placemark
                        //self.mapView.addAnnotation(placemark)
                        let name = mapItem.name
                        let coordinate = placemark.coordinate
                        let streetAddress = placemark.thoroughfare
                        let annotation = PizzaAnnotation(coordinate: coordinate, title: name, subtitle: streetAddress)
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        }*/
        let annotations = PizzaHistoryAnnotations().annotations
        //let SPGO = annotations[5].coordinate
        //let CPK = annotations[6].coordinate
        let CPOG = annotations[4].coordinate
        let UNO = annotations[2].coordinate
        //findDirections(start: SPGO, destination: CPK)
        findDirections(start: CPOG, destination: UNO)
        
        
    }

    @IBAction func locationPicker(_ sender: UISegmentedControl) {
        disableLocationServices()
        let index = sender.selectedSegmentIndex
        //mapView.removeAnnotations(mapView.annotations)
        switch index {
        case 0: //Naples
           coordinate2D = CLLocationCoordinate2DMake(40.8367321,14.2468856)
        case 1: //New York
            coordinate2D = CLLocationCoordinate2DMake(40.7216294 , -73.995453)
            updateMapCamera(heading: 245.0, altitude: 250)
            //let pizzaPin = PizzaAnnotation(coordinate: coordinate2D, title: "New York Pizza", subtitle: "Pizza Comes to America")
           // mapView.addAnnotation(pizzaPin)
            return
        case 2: //Chicago
            coordinate2D = CLLocationCoordinate2DMake(41.892479 , -87.6267592)
            updateMapCamera(heading: 0 , altitude: 15000)
            return
        case 3: //Chatham
            coordinate2D = CLLocationCoordinate2DMake(42.4056555,-82.1860369)
            updateMapCamera(heading: 180, altitude: 1000)
            return
        case 4: //Beverly Hills
            coordinate2D = CLLocationCoordinate2DMake(34.0674607,-118.3977309)
            let pizzaPin = MKPointAnnotation()
            pizzaPin.coordinate = coordinate2D
            pizzaPin.title = "Fusion Cuisine Pizza"
            pizzaPin.subtitle = "Also known as California Pizza"
            //mapView.addAnnotation(pizzaPin)
            updateMapCamera(heading: 0, altitude: 1500)
            return
        default:
            coordinate2D = CLLocationCoordinate2DMake(40.8367321,14.2468856)
        }
        updateMapRegion(rangeSpan: 100)
    }
    //MARK: - Instance Methods
    func updateMapRegion(rangeSpan:CLLocationDistance){
        let region = MKCoordinateRegion(center: coordinate2D, latitudinalMeters: rangeSpan, longitudinalMeters: rangeSpan)
        mapView.region = region
    }
    func updateMapCamera(heading:CLLocationDirection, altitude:CLLocationDistance){
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
    func addPolylines(){
    let annotations = PizzaHistoryAnnotations().annotations
        let beverlyHills1 = annotations[5].coordinate
        let beverlyHills2 = annotations[6].coordinate
        let bhPolyline = MKPolyline(coordinates: [beverlyHills1,beverlyHills2], count: 2)
        bhPolyline.title = "BeverlyHills_Line"
        var coordinates = [CLLocationCoordinate2D]()
        for location in annotations{
            coordinates.append(location.coordinate)
        }
        let grandTour = MKPolyline(coordinates: coordinates, count: coordinates.count)
        grandTour.title = "GrandTour_Line"
        mapView.addOverlays([grandTour,bhPolyline])
    }
    
    func addDeliveryOverlay(){
        //let radius = 1600.0 //meters
        for location in mapView.annotations{
            if let radius = (location as! PizzaAnnotation).deliveryRadius{
                let circle = MKCircle(center: location.coordinate, radius: radius)
                mapView.addOverlay(circle)
            }
            
        }
    }
    //MARK: Location
    func setupCoreLocation(){
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedAlways:
            enableLocationServices()
        default:
            break
        }
    }
    
    func enableLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            mapView.setUserTrackingMode(.follow, animated: true)
        }
        if CLLocationManager.headingAvailable(){
            locationManager.startUpdatingHeading()
        } else {
            print("heading not available")
        }
        monitorRegion(center: onRampCoordinate, radius: 100.0, id: "On ramp")
    
    }
    
    func disableLocationServices(){
        locationManager.stopUpdatingLocation()
    }
    
    func monitorRegion(center:CLLocationCoordinate2D, radius:CLLocationDistance, id:String){
        if CLLocationManager.authorizationStatus() == .authorizedAlways{
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
                let region = CLCircularRegion(center: center, radius: radius, identifier: id)
                region.notifyOnExit = true
                region.notifyOnEntry = true
                locationManager.startMonitoring(for: region)
                
            }
        }
    }
    //MARK: Find
    func getCoordinate( address:String, completionHandler: @escaping(CLLocationCoordinate2D?,String, NSError?)->Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0]{
                    let coordinate = placemark.location?.coordinate
                    let location = placemark.locality! + " " + placemark.isoCountryCode!
                    completionHandler(coordinate, location, nil)
                    return
                }
            }
            completionHandler(nil, "", error as NSError?)
        }
    }
    //MARK: Directions
    func findDirections(start:CLLocationCoordinate2D,destination:CLLocationCoordinate2D){
        startMapItem = MKMapItem(placemark: MKPlacemark(coordinate: start))
        destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        let request = MKDirections.Request()
        request.source = startMapItem
        request.destination = destinationMapItem
        request.requestsAlternateRoutes = true
        request.transportType = .transit
        let directions = MKDirections(request: request)
        if request.transportType == .transit{
            directions.calculateETA(completionHandler: { (response, error) in
                let annotation = PizzaAnnotation(coordinate: destination, title: "Destination", subtitle: "No Transit Available")
                if let response = response{
                    annotation.subtitle = String(format: "%4.2f minutes", response.expectedTravelTime/60.0)
                    
                }
                annotation.id = "Transit"
                self.mapView.addAnnotation(annotation)
            })
            
            return
        }
        directions.calculate { (response, error) in
            if let error = error as? MKError{
                print ("Error in find:\(error.errorCode) \(error.localizedDescription)")
                return
            }
            if let response = response{
                let routes = response.routes
                print("\(routes.count) routes")
                for route in routes{
                    
                    let polyline = route.polyline
                    polyline.title = "Directions"
                    self.mapView.addOverlay(polyline)
                }
                let destination = response.destination.placemark.coordinate
                let route = routes.first!
                var routeDescription =  route.name + "\(route.expectedTravelTime/60.0) min \(route.distance/1609.344) miles "
                let annotation = PizzaAnnotation(coordinate: destination, title: "Destination", subtitle: routeDescription)
                for routeStep in route.steps{
                    routeDescription += routeStep.instructions + ". Go \(routeStep.distance/1609.334) mi \n"
                    self.mapView.addOverlay(routeStep.polyline)
                }
                annotation.historyText = routeDescription
                self.mapView.addAnnotation(annotation)
            }
        }
        
    }
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

    //MARK: - Delegates
    //MARK: Annotation delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        guard let annotation = annotation as? PizzaAnnotation
        else{
                return nil
        }
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.id) {
            annotationView = dequedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.id)
        }
        //annotationView.pinTintColor = UIColor.blue
        if annotation.title == "Destination"{
            annotationView.image = UIImage(named: "destination")
        }else{
            annotationView.image = UIImage(named: "pizza pin")
        }
        annotationView.canShowCallout = true
        let paragraph = UILabel()
        paragraph.numberOfLines = 0
        paragraph.font = UIFont.preferredFont(forTextStyle: .caption1)
        paragraph.text = annotation.subtitle
        paragraph.numberOfLines = 1
        paragraph.adjustsFontSizeToFitWidth = true
        annotationView.detailCalloutAccessoryView = paragraph
        if annotation.pizzaPhoto == nil{ //default image
            annotation.pizzaPhoto = UIImage(named: "pizza pin")
        }
        annotationView.leftCalloutAccessoryView = UIImageView(image: annotation.pizzaPhoto)
        annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! PizzaAnnotation
        if annotation.id == "Transit" {
            destinationMapItem.name = "Pizza Pot Pie"
            startMapItem.name = "Deep Dish Pizza"
            MKMapItem.openMaps(with: [destinationMapItem,startMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit])
        }
        let vc = AnnotationDetailViewController(nibName: "AnnotationDetailViewController", bundle: nil)
        vc.annotation = view.annotation as! PizzaAnnotation
        present(vc, animated: true, completion: nil)
    }
    //MARK: Overlay delegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline{
            let polylineRenderer = MKPolylineRenderer(polyline: polyline)
            if polyline.title == "GrandTour_Line"{
                polylineRenderer.strokeColor = UIColor.red
                polylineRenderer.lineWidth = 5.0
                return polylineRenderer
            }
            if polyline.title == "Directions"{
             polylineRenderer.strokeColor = UIColor.blue
                polylineRenderer.lineWidth = 3.0
                return polylineRenderer
            }
            polylineRenderer.strokeColor = UIColor.green
            polylineRenderer.lineWidth = 3.0
            polylineRenderer.lineDashPattern = [20,10,2,10]
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
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let circularRegion = region as! CLCircularRegion
        if circularRegion.identifier == "On ramp"{
            let alert = UIAlertController(title: "Pizza History", message: "You are on the ramp", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let circularRegion = region as! CLCircularRegion
        if circularRegion.identifier == "On ramp"{
            let alert = UIAlertController(title: "Pizza History", message: "You are on the freeway", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("authorized")
        case .denied, .restricted:
            print("not authorized")
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        coordinate2D = location.coordinate
        let speedString = "\(location.speed * 2.23694) mph"
        let headingString = " Heading: \(heading)º"
        let courseString = headingString + " at " + speedString
        print(courseString)
        let displayString = "\(location.timestamp) Coord:\(coordinate2D) Alt: \(location.altitude) meters"
        print(displayString)
        updateMapRegion(rangeSpan: 200)
        let pizzaPin = PizzaAnnotation(coordinate: coordinate2D, title: displayString, subtitle: "")
        mapView.addAnnotation(pizzaPin)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.magneticHeading
    }

}

