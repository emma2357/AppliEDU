//
//  ContentView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 4/24/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn

// Overarching view that sends logged in users to home and new users/logged out users to login
struct ContentView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        VStack {
            //show diffent views depending on sign in state
            if (dataModel.state == DataModel.SignInState.signedIn) {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            // initialize environment object
            .environmentObject(DataModel(user: UserInfo(email: "", username: "", userType: UserType.studentAccount, age: "", location: "6 Woodhaven Drive", coordinates: ["1", "2"])))
    }
}
