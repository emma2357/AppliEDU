//
//  HomeView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn

// Home page for users already signed in
struct HomeView: View {
    @State private var selection: String? = nil
    @State var username: String = ""
    @EnvironmentObject var dataModel: DataModel
    
    var db = Firestore.firestore()
    
    var user = GIDSignIn.sharedInstance.currentUser
    
    var body: some View {
        VStack {
            // sign in options
            if (dataModel.user.email == "nil") {
                SignUpView()
            } else if (dataModel.user.userType == UserType.studentAccount) {
                StudentAccountView()
            } else {
                BusinessAccountView()
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
