//
//  StudentAccountView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 4/27/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn

// track what tab the user is on
enum StudentTabs {
    case searchJobs
    case bookmarks
    case applications
    case settings
}

// student tab view
struct StudentAccountView: View {
    @State var activeTab = StudentTabs.searchJobs
    @State var username = "hello"
    
    var appInfo = AppInfo()
    
    var body: some View {
        NavigationView {
            TabView (selection: $activeTab){
                SearchJobsView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)
                BookmarksView()
                    .tabItem {
                        Image(systemName: "bookmark")
                        Text("Bookmarks")
                    }
                    .tag(2)
                ApplicationsTabView()
                    .tabItem {
                        Image(systemName: "tray.full")
                        Text("Applications")
                    }
                    .tag(3)
                ResourcesView()
                    .tabItem {
                        Image(systemName: "lightbulb")
                        Text("Resources")
                    }
                    .tag(3)
                StudentSettingsView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                    .tag(4)
            }.accentColor(appInfo.backgroundBlueColor)
        }
    }
} 

struct StudentAccountView_Previews: PreviewProvider {
    static var previews: some View {
        StudentAccountView()
            .environmentObject(DataModel(user: UserInfo(email: "", username: "", userType: UserType.studentAccount, age: "", location: "6 Woodhaven Drive", coordinates: ["1", "2"])))
    }
}
