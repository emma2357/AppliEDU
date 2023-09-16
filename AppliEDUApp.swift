//
//  AppliEDUApp.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 4/24/23.
//

import SwiftUI
import Firebase

@main
struct AppliEDUApp: App {
    // initialize firebase
    init() {
        FirebaseApp.configure()
    }
    
    // create dataModel as environmental object
    @StateObject var dataModel = DataModel(user: UserInfo(email: "starbucks@gmail.com", username: "", userType: UserType.studentAccount, age: "", location: "6 Woodhaven Drive", coordinates: ["1", "2"]))
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataModel)
        }
    }
}
