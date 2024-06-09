//
//  SetLocationViewController.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/7/24.
//

import UIKit
import MapKit

class SetLocationViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var locationTextView: UITextView!
    var geocodedLocation: CLLocationCoordinate2D?
    var geocodeSuccess: Bool = false
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationTextView.text = "Nashville, Tennessee"
        locationTextView.textColor = .lightGray
//        locationTextView.backgroundColor = .blue
        
        locationTextView.delegate = self

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        locationTextView.text = nil
        locationTextView.textColor = UIColor.black
    }
    

    func textViewDidEndEditing(_ textView: UITextView) {
        if locationTextView.text.isEmpty {
            locationTextView.text = "Enter your location here"
            locationTextView.textColor = .lightGray
        }
    }
    
    
    @IBAction func findOnMap(_ sender: UIButton) {
        let inputAddress = locationTextView.text!
        geocodeAddress(inputAddress)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "geocode" {
            let geocodeVC = segue.destination as! PostLocationViewController
            geocodeVC.geocodedLocation = geocodedLocation
            geocodeVC.address = locationTextView.text!
            geocodeVC.geocodeSuccess = geocodeSuccess
        }
    }
    
    
    func geocodeAddress(_ address: String) {
        activityIndicator.startAnimating()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placements, error in
            self.activityIndicator.stopAnimating()
            
            if let error = error {
                self.geocodeSuccess = false
                self.performSegue(withIdentifier: "geocode", sender: nil)
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            guard let placement = placements?.first, let location = placement.location else {
                print("No location found")
                self.geocodeSuccess = false
                self.performSegue(withIdentifier: "geocode", sender: nil)
                return
            }
            self.geocodedLocation = location.coordinate
            self.geocodeSuccess = true
            self.performSegue(withIdentifier: "geocode", sender: nil)
//            self.addAnnotation(location: location, title: address)
        }
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
