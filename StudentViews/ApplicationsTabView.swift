//
//  ApplicationsTabView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI

// Page that shows applications in progress and completed
struct ApplicationsTabView: View {
    @EnvironmentObject var dataModel: DataModel
    
    @State var inProgressCount = 0
    @State var completedCount = 0
    
    func increaseProgressCount() -> Void {
        inProgressCount += 1
    }
    
    func increaseCompletedCount() -> Void {
        completedCount += 1
    } 
    
    var appInfo = AppInfo()
    
    var body: some View {
        ScrollView {
            VStack {
               Text("Applications In Progress")
                    .font(Font.custom(appInfo.font, size: appInfo.title))
                
                // keep track of number of applications in progress
                ForEach(0..<dataModel.jobs.count, id: \.self){ i in
                    if let studentJob = dataModel.studentJobs.first(where: {$0.jobID == dataModel.jobs[i].id}){
                        if(studentJob.applicationProgress == ApplicationProgress.applicationInProgress) {
                            CondensedStudentJobView(job: dataModel.jobs[i])
                                .onAppear(perform: {
                                    increaseProgressCount()
                                })
                        }
                    }
                }
                
                // if no apps in progress, show 'None Yet'
                if (inProgressCount == 0) {
                    Spacer()
                        .frame(height: 20)
                    Text("None Yet")
                        .font(Font.custom(appInfo.font, size: appInfo.body))
                }
            }
            Spacer()
                .frame(height: 30)
            VStack {
                Text("Applications Completed")
                    .font(Font.custom(appInfo.font, size: appInfo.title))

                // keep tract of number of applications completed
                ForEach(0..<dataModel.jobs.count, id: \.self){ i in
                    if let studentJob = dataModel.studentJobs.first(where: {$0.jobID == dataModel.jobs[i].id}){
                        if(studentJob.applicationProgress == ApplicationProgress.applicationCompleted) {
                            CondensedStudentJobView(job: dataModel.jobs[i])
                                .onAppear(perform: {
                                    increaseCompletedCount()
                                })
                        }
                    }
                }
                
                // if no apps completed, show 'None Yet'
                if (completedCount == 0) {
                    Spacer()
                        .frame(height: 20)
                    Text("None Yet")
                        .font(Font.custom(appInfo.font, size: appInfo.body))
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            inProgressCount = 0
            completedCount = 0
        }
    }
}

struct ApplicationsTabView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationsTabView()
            .environmentObject(DataModel(user: UserInfo(email: "example@gmail.com", username: "Emma Capaldi", userType: UserType.studentAccount, age: "16", location: "6 Woodhaven Drive", coordinates: ["1", "2"])))
    }
}
