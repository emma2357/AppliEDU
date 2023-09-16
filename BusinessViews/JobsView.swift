//
//  JobsView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI

// Home page for business view (all jobs created by this organization)
struct JobsView: View {
    @EnvironmentObject var dataModel: DataModel
    var appInfo = AppInfo()
    
    var body: some View {
        VStack {
            HStack {
                Text("Posted Positions")
                    .padding()
                    .font(Font.custom(appInfo.font, size: appInfo.title))
                
                Spacer()
                
                // Create a new position using this button
                NavigationLink("New Position", destination: NewJobView())
                    .foregroundColor(appInfo.whiteAccent)
                    .padding()
                    .background{
                        appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .font(Font.custom(appInfo.font, size: appInfo.title2))
                
                Spacer()
                    .frame(width: 20)
            }
            
            Spacer()
                .frame(height: 20)
            
            // display jobs created by this user
            ScrollView {
                ForEach(0..<dataModel.jobs.count, id: \.self){ i in
                    if (dataModel.jobs[i].business == dataModel.user.username){
                        CondensedBusinessJobView(job: dataModel.jobs[i])
                    }
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(Font.custom(appInfo.font, size: appInfo.body))
    }
}

struct JobsView_Previews: PreviewProvider {
    static var previews: some View {
        JobsView()
            .environmentObject(DataModel(user: UserInfo(email: "example@gmail.com", username: "Emma Capaldi", userType: UserType.businessAccount, businessDescription: "We love to make coffee and also sell coffee and really we're great", location: "6 woodhaven drive, woodhaven drive, andover",coordinates: ["",""])))
    }
}
