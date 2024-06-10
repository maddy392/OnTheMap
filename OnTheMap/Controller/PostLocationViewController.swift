//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/7/24.
//

import UIKit
import MapKit
import CoreLocation

class PostLocationViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var address: String?
    var geocodedLocation: CLLocationCoordinate2D?
    var geocodeSuccess: Bool = false
    @IBOutlet weak var mediaURLTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if geocodeSuccess, let location = geocodedLocation, let address = address {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = address
            mapView.addAnnotation(annotation)
            mapView.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)), animated: true)
        }
        
        else {
            self.submitButton.isHidden = true
            showAlertAndReturn()
        }
        
        mediaURLTextView.delegate = self
        mediaURLTextView.text = "https://google.com"
        mediaURLTextView.textColor = .lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        mediaURLTextView.text = nil
        mediaURLTextView.textColor = UIColor.black
    }
    

    func textViewDidEndEditing(_ textView: UITextView) {
        if mediaURLTextView.text.isEmpty {
            mediaURLTextView.text = "Enter your location here"
            mediaURLTextView.textColor = .lightGray
        }
    }
    
    
    func showAlertAndReturn() {
        let alertVC = UIAlertController(title: "Login Failed", message: "Geocoding Failed. Please try again!\n Couldn't geocode '\(address ?? "")'", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in self.navigationController?.popViewController(animated: true)}))
        present(alertVC, animated: true, completion: nil)
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
        
        let postStudentLocationBody = PostStudentLocation(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString!, mediaURL: mediaURL!, latitude: latitude, longitude: longitude)
        
        UdacityClient.postStudentLocation(studentInfo: postStudentLocationBody) { success, error in
            print(success)
            if success {
                DispatchQueue.main.async {
                    if let tabBarController = self.tabBarController {
                        tabBarController.selectedIndex = 0 // Switch to the map view tab
                            if let navigationController = tabBarController.viewControllers?[0] as? UINavigationController {
                                print(navigationController.viewControllers)
                                if let firstTabVC = navigationController.viewControllers.first as? StudentMapViewController {
                                    print("instantiated firstabVC as studentmapviewcontroller")
                                    firstTabVC.initialLocation = CLLocation(latitude: latitude, longitude: longitude)
                                    navigationController.popToRootViewController(animated: true)
                                }
                            }
                    }
                }
            } else {
                print("post student loc failed")
                DispatchQueue.main.async {
                    self.showAlert(error?.localizedDescription ?? "")
                }
            }
        }
        
    }
    
    func showAlert(_ message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

}
