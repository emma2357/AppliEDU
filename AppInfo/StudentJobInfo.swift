//
//  StudentJobInfo.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/14/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// data structure for student job information
struct StudentJobInfo: Identifiable, Codable, Hashable {
    @DocumentID var id = UUID().uuidString
    // link to job and student through ids
    var jobID: String
    var userID: String

    var bookmarked: Bool
    var applicationProgress: ApplicationProgress
    var application: ApplicationInfo
    
    init(jobID: String, userID: String, bookmarked: Bool, applicationProgress: ApplicationProgress, application: ApplicationInfo) {
        self.jobID = jobID
        self.userID = userID
        self.bookmarked = bookmarked
        self.applicationProgress = applicationProgress
        self.application = application
    }
}

// Enum for tracking application progress
enum ApplicationProgress: Codable, Hashable {
    case noApplication
    case applicationInProgress
    case applicationCompleted
}


