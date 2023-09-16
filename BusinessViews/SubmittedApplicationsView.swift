//
//  SubmittedApplicationsView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI

// Create submitted application subview for submitted application page
struct SubmittedApplicationsView: View {
    @EnvironmentObject var dataModel: DataModel
    @State var selection: String? = nil

    var job: JobInfo
    
    var appInfo = AppInfo()

    var body: some View {
        VStack {
            // Open this particular application
            NavigationLink(destination: ExpandedStudentAppView(application: job.applicationInfo), tag: "Expand", selection: $selection) { EmptyView() }
            Text("Submitted Applications for \(job.jobName)")
                .font(Font.custom(appInfo.font, size: appInfo.title2))

            ScrollView {
                // show submitted applications for this job
                ForEach(0..<dataModel.studentJobs.count, id: \.self){ i in
                    if(dataModel.studentJobs[i].jobID == job.id){
                        Button(action: {
                            selection = "Expand"
                        }){
                            VStack {
                                Text("Applicant: \(dataModel.studentJobs[i].application.name)")
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.black)
                                    .frame(width: appInfo.maxWidth - 60)
                            }
                        }.padding()
                            .background{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                            }
                            .padding([.leading, .trailing], 100)
                            .padding(5)
                    }
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(Font.custom(appInfo.font, size: appInfo.body))
    }
}

struct SubmittedApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        SubmittedApplicationsView(job: JobInfo(jobName: "", business: "", businessLocation: "", businessDescription: "", payRange: "", location: "", coordinates: ["0", "0"], minAge: "13", timeSchedule: [TimeSchedule(day: "Mon", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Tues", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Wed", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Thurs", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Fri", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sat", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sun", showDay: false, startTime: "", endTime: "")], tags: [""], applicationInfo: ApplicationInfo(name: "", requireEmail: false, email: "", requirePhoneNumber: false, phoneNumber: "", questions: [AppQuestion(question: "", answer: "")], otherInfo: "", resumeURL: ""), jobDescription: ""))
            .environmentObject(DataModel(user: UserInfo(email: "selinacermainta@gmail.com", username: "Selina", userType: UserType.businessAccount, businessDescription: "", location: "6 Woodhaven Drive",coordinates: ["",""])))
    }
}
