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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        reloadMapData()
        
//        // Do any additional setup after loading the view.
//        let _ = UdacityClient.getStudentList { students, error in
//            StudentList.studentList = students
////            print(StudentList.annotations)
//            
//            DispatchQueue.main.async {
//                self.reloadMapData()
//            }
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Map View"
        self.reloadMapData()
    }
    
    func reloadMapData() {
        
        let _ = UdacityClient.getStudentList { students, error in
            print("Fetching student data")
            StudentList.studentList = students
            
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(StudentList.annotations)
            }
        }
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
