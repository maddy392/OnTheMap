//
//  SetLocationViewController.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/7/24.
//

import UIKit

class SetLocationViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var locationTextView: UITextView!
    
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
        performSegue(withIdentifier: "geocode", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "geocode" {
            let geocodeVC = segue.destination as! PostLocationViewController
            geocodeVC.address = locationTextView.text
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
