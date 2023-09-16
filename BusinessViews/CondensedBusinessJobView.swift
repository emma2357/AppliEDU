//
//  CondensedBusinessJobView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI

// display basic job information for home page
struct CondensedBusinessJobView: View {
    var job: JobInfo
    
    var appInfo = AppInfo()
    @State var selection: String? = nil
    
    var body: some View {
        // Take user to page with applications for this particular job
        NavigationLink(destination: SubmittedApplicationsView(job: job), tag: "Expand", selection: $selection) { EmptyView() }
        Button(action: {
            selection = "Expand"
        }){
            VStack(alignment: .leading) {
                Text("\(job.jobName)")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: appInfo.maxWidth - 60)
                    .foregroundColor(.black)
            }
            }.padding()
                .background{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                }
                .padding()
        
    }
}

struct CondensedBusinessJobView_Previews: PreviewProvider {
   static var previews: some View {
       CondensedBusinessJobView(job: JobInfo(jobName: "", business: "", businessLocation: "", businessDescription: "", payRange: "", location: "", minAge: "13", timeSchedule: [TimeSchedule(day: "Mon", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Tues", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Wed", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Thurs", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Fri", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sat", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sun", showDay: false, startTime: "", endTime: "")], tags: [""], applicationInfo: ApplicationInfo(name: "", requireEmail: false, email: "", requirePhoneNumber: false, phoneNumber: "", questions: [AppQuestion(question: "", answer: "")], otherInfo: ""), jobDescription: ""))
   }
}
