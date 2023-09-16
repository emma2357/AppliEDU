//
//  UserInfo.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/14/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

import CoreLocation

// data structure for user information
struct UserInfo: Identifiable, Codable, Hashable {
    @DocumentID var id = UUID().uuidString
    var email: String
    var username: String
    var userType: UserType
    var age: String = ""
    var businessDescription: String = ""
    var location: String = ""
    var coordinates: [String] = ["", ""]
    var resumeInfo = ResumeInfo()
    
    // Initializer for student
    init(email: String, username: String, userType: UserType, age: String, location: String, coordinates: [String]) {
        self.email = email
        self.username = username
        self.userType = userType
        self.age = age
        self.location = location
        self.coordinates = coordinates
    }
    
    // initializer for organization
    init(email: String, username: String, userType: UserType, businessDescription: String, location: String, coordinates: [String]) {
        self.email = email
        self.username = username
        self.userType = userType
        self.businessDescription = businessDescription
        self.location = location
        self.coordinates = coordinates 
    }
    
    // converting information from google sign-in to user 
    mutating func docToUser(document: [String: Any], documentID: String) {
        self.email = document["email"] as! String
        self.username = document["username"] as! String
        self.userType = document["userType"] as! String == "student" ? UserType.studentAccount : UserType.businessAccount
        self.age = document["age"] as! String
        self.businessDescription = document["businessDescription"] as! String
        self.location = document["location"] as! String
        self.id = documentID
    }
    
    // Geocoding (convert location to coordinates)
    func getCoordinatesFromLocation(address: String, saveCoordinates: @escaping (_ lat: String, _ long: String) -> Void) -> Void {
        print("start")
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error != nil {
                    print("Failed to retrieve location")
                    return
                }
                
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    let coordinate = location.coordinate
                    saveCoordinates( "\(coordinate.latitude)", "\(coordinate.longitude)")
                    
                    print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
                }
                else
                {
                    print("No Matching Location Found")
                }
            })
        print("done")
        }
}

// Struct for information related to resume
struct ResumeInfo: Codable, Hashable {
    var fullName: String = ""
    var showPhoneNumber: Bool = true
    var phoneNumber: String = ""
    var showEmail: Bool = true
    var email: String = ""
    var schoolName: String = ""
    var gpa: String = ""
    var jobsVolunteering: String = ""
    var clubs: String = ""
    var hobbies: String = ""
}

/// Enum for tracking user type
enum UserType: String, Codable, Hashable {
    case studentAccount = "student"
    case businessAccount = "business"
}
