//
//  StudentList.swift
//  OnTheMap
//
//  Created by MadhuBabu Adiki on 6/4/24.
//

import Foundation
import MapKit


class StudentList {
    static var studentList = [Student]()
    
    static var annotations: [MKAnnotation] {
        return studentList.map { student in
            return createAnnotation(student: student)
        }
    }
}
