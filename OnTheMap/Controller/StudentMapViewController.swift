//
//  StudentMapViewController.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/5/24.
//

import UIKit
import MapKit

class StudentMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    // used initialLocation variable so that when student submits a location, the map focuses on that location
    var initialLocation: CLLocation?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Map View"
        self.reloadMapData()
        
        if let initialLocation = initialLocation {
            setInitialLocation(location: initialLocation)
        }
    }
    
    
    func reloadMapData() {
        let _ = UdacityClient.getStudentList { students, error in
            print("Fetching student data")
//            print(students.isEmpty)
            if !students.isEmpty {
                StudentList.studentList = students
                
                DispatchQueue.main.async {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotations(StudentList.annotations)
                }
            } else {
                self.showTapFailure(message: "Students' Location Download Failed.")
                print("Fetching student data failed")
            }
        }
    }
    
    func setInitialLocation(location: CLLocation, regionRadius: CLLocationDistance = 5000000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else {return nil}
        let identifier = "StudentAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation, let subtitle = annotation.subtitle, let urlString = subtitle {
//            print(urlString)
            if let url = URL(string: urlString), isValidURL(urlString) {
//                print("opening url")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
//                print("not a valid url")
                showTapFailure(message: "URL:\(urlString) is not a valid URL")
            }
        }
    }
    
    func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    func showTapFailure(message: String) {
        let alertVC = UIAlertController(title: "Invalid mediaURL", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    
    @IBAction func postALocation(_ sender: Any) {
        performSegue(withIdentifier: "addLocation", sender: nil)
    }
    

}
