//
//  JobInfo.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/14/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

// Data structure for job information
struct JobInfo: Identifiable, Codable, Hashable {
    @DocumentID var id = UUID().uuidString
    var jobName: String
    var business: String
    var businessLocation: String
    var businessDescription: String
    var hasPay: Bool = false
    var payRange: String
    
    var hasLocation: Bool = false
    var location: String
    var coordinates: [String]
    
    var hasMinAge: Bool = false
    var minAge: String
    
    var timeSchedule: [TimeSchedule]
    var tags: [String]
    var applicationInfo: ApplicationInfo
    var jobDescription: String
    
    // only for filter
    var distance: Double = 1000
}

// Data structure of application information
struct ApplicationInfo: Codable, Hashable {
    var name: String

    var requireEmail: Bool
    var email: String
    var requirePhoneNumber: Bool
    var phoneNumber: String
    
    var questions: [AppQuestion]
    
    var otherInfo: String
    
    var resumeURL: String
}

// Struct for application question information
struct AppQuestion: Codable, Hashable {
    var question: String
    var answer: String
}

//Struct for organizing hours information
struct TimeSchedule: Codable, Hashable {
    var day: String
    var showDay: Bool
    var startTime: String
    var endTime: String
}

// Struct for job options for creating and filtering jobs
struct JobOptions {
    var payRange = Array(stride(from: 0.00, to: 50.00, by: 0.01))
    
    // hours restricted by age
    func getHourRange(age: Int) -> [String] {
        var array = [""]
        if (age == -1) {
            for i in (0 ..< 24) {
                array.append("\(i):00")
                array.append("\(i):30")
            }
            return array
        } else if (age <= 15){
            for i in (7 ..< 21) {
                array.append("\(i):00")
                array.append("\(i):30")
            }
            return array
        } else if (age <= 17) {
            for i in (6 ..< 22) {
                array.append("\(i):00")
                array.append("\(i):30")
            }
            return array
        } else {
            for i in (0 ..< 24) {
                array.append("\(i):00")
                array.append("\(i):30")
            }
            return array
        }
    }
    
    func getMinAge(age: Int) -> [String] {
        var array = [""]
        if (age >= 13) {
            for i in (13 ..< age + 1) {
                array.append("\(i)")
            }
            return array
        }else {
            for i in (13 ..< 18) {
                array.append("\(i)")
            }
            return array
        }
    }
    
    var tagOptions = ["Volunteering", "Internship", "Mentoring", "Communication", "STEM", "Photo/Video Editing", "Tech Knowledge Recommended", "Flexible Hours", "Virtual"]
}
