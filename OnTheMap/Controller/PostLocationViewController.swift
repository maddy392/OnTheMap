//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/7/24.
//

import UIKit
import MapKit
import CoreLocation

class PostLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var address: String!
    var geocodedLocation: CLLocationCoordinate2D?
    @IBOutlet weak var mediaURLTextView: UITextView!
    //    let initialLocation = CLLocation(latitude: 36.1627, longitude: -86.7816)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        setInitialLocation(location: initialLocation)
        geocodeAddress(address)
    }
    
    
    func geocodeAddress(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placements, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            guard let placement = placements?.first, let location = placement.location else {
                print("No location found")
                return
            }
            self.geocodedLocation = location.coordinate
            self.addAnnotation(location: location, title: address)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let identifier = "myAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
//    func setInitialLocation(location: CLLocation, regionRadius: CLLocationDistance = 10000) {
//        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
    
    func addAnnotation(location: CLLocation, title: String) {
//        print("starting to annotate")
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
//        mapView.selectAnnotation(annotation, animated: true)
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        mapView.setRegion(coordinateRegion, animated: true)
//        setInitialLocation(location: location)
    }
    

    @IBAction func submitTapped(_ sender: UIButton) {
        print("Submit button tapped")
        
        guard let coordinate = geocodedLocation else {
            print("No Location Found")
            return
        }
        
        let mediaURL = self.mediaURLTextView.text
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        let uniqueKey = UdacityClient.Auth.udacityAccountId
        let firstName = UdacityClient.Auth.firstName
        let lastName = UdacityClient.Auth.lastName
        let mapString = address
        
        UdacityClient.postStudentLocation(studentInfo: PostStudentLocation(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString!, mediaURL: mediaURL!, latitude: latitude, longitude: longitude)) { success, error in
            if success {
                DispatchQueue.main.async {
                    if let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController {
                        navigationController.popToRootViewController(animated: true)
                    }
                }
            } else {
                print("post student loc failed")
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
