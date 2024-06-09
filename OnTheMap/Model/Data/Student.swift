//
//  Student.swift
//  OnTheMap
//
//  Created by MadhuBabu Adiki on 6/4/24.
//

import Foundation
import MapKit

struct Student: Codable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

// MARK: convert student info into usabel annotations
func createAnnotation(student: Student) -> MKPointAnnotation {
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
    annotation.title = "\(student.firstName)" + " " + "\(student.lastName)"
    annotation.subtitle = student.mediaURL
    return annotation
}
