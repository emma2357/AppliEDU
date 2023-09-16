//
//  BusinessAccountView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 4/27/23.
//

import SwiftUI
import GoogleSignIn

// Track the current tab
enum BusinessTabs {
    case jobs
    case submittedApplications
    case settings
}

// business account tab view
struct BusinessAccountView: View {
    @State var activeTab = BusinessTabs.jobs
    
    var appInfo = AppInfo()
    
    var body: some View {
        NavigationView {
            TabView (selection: $activeTab){
                JobsView()
                    .tabItem {
                        Image(systemName: "tray.full")
                        Text("Jobs")
                    }
                    .tag(1)
                
                BusinessSettingsView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                    .tag(2)
            }.accentColor(appInfo.backgroundBlueColor)
        }
    }
}

//struct BusinessAccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        BusinessAccountView()
//    }
//}
