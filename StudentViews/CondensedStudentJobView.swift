//
//  CondensedStudentJobView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//
import SwiftUI

// Page that creates subview for displaying jobs on the home page
struct CondensedStudentJobView: View {
    @State var bookmarked: Bool = false
    
    @EnvironmentObject var dataModel: DataModel
    @State var studentJob: StudentJobInfo = StudentJobInfo(jobID: "nil", userID: "nil", bookmarked: false, applicationProgress: ApplicationProgress.noApplication, application: ApplicationInfo(name: "", requireEmail: false, email: "", requirePhoneNumber: false, phoneNumber: "", questions: [AppQuestion(question: "", answer: "")], otherInfo: "", resumeURL: ""))
    @State var selection: String? = nil
    var job: JobInfo
    var appInfo = AppInfo()
    
    var body: some View {
        NavigationLink(destination: ExpandedJobView(job: job), tag: "Expand", selection: $selection) { EmptyView() }
        Button(action: {
            selection = "Expand"
        }){
            VStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("\(job.jobName)")
                                .font(Font.custom(appInfo.font, size: appInfo.title2))
                            Text("\(job.business)")
                        }
                        
                        Spacer()
                        
                        // bookmark jobs
                        Button {
                            studentJob.bookmarked.toggle()
                            dataModel.updateStudentJob(studentJob)
                        } label: {
                            if (studentJob.bookmarked) {
                                Image(systemName: "bookmark.fill")
                                    .resizable()
                                    .frame(width: 20, height: 35)
                                    .foregroundColor(Color(hue: 0.142, saturation: 0.989, brightness: 0.853))
                            } else {
                                Image(systemName: "bookmark")
                                    .resizable()
                                    .frame(width: 20, height: 35)
                                    .foregroundColor(Color(hue: 0.142, saturation: 0.989, brightness: 0.853))
                            }
                        }
                    }
                    
                    HStack {
                        Image(systemName: "pin")
                            .resizable()
                            .frame(width: 10, height: 15)
                        Text("\(job.location)")
                    }
                }
                
                HStack {
                    if(job.hasPay) {
                        Text("Pay: \(job.payRange)")
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0 ..< job.timeSchedule.count, id: \.self) { i in
                                if (job.timeSchedule[i].showDay) {
                                    Text("\(job.timeSchedule[i].day) \(job.timeSchedule[i].startTime) - \(job.timeSchedule[i].endTime)")
                                        .foregroundColor(.black)
                                        .padding(7)
                                        .background{
                                            appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    ScrollView(.horizontal) {
                        HStack {
                            Text("\(job.minAge)+")
                                .foregroundColor(.black)
                                .padding(7)
                                .background{
                                    appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            ForEach(1 ..< job.tags.count, id: \.self) { i in
                                Text("\(job.tags[i])")
                                    .foregroundColor(.black)
                                    .padding(7)
                                    .background{
                                        appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                            }
                        }
                    }
                }
            }
        }.onAppear(perform: {
            // if job is not already in studentJob array, add
            if let studentJob = dataModel.studentJobs.first(where: {$0.jobID == job.id}) { // [1]
                self.studentJob = studentJob
            } else {
                // if it is in the array, get information
                let newStudent = StudentJobInfo(jobID: job.id ?? "nil", userID: dataModel.user.id ?? "nil", bookmarked: false, applicationProgress: ApplicationProgress.noApplication, application: job.applicationInfo)
                studentJob = newStudent
                dataModel.addStudentJob(newStudent)
            }
        })
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 15)
                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
        }
        .padding()
        .foregroundColor(Color(.black))
        .font(Font.custom("\(appInfo.font)", size: appInfo.body))
    }
}

struct CondensedStudentJobView_Previews: PreviewProvider {
   static var previews: some View {
       CondensedStudentJobView(job: JobInfo(jobName: "", business: "", businessLocation: "", businessDescription: "", payRange: "", location: "", minAge: "13", timeSchedule: [TimeSchedule(day: "Mon", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Tues", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Wed", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Thurs", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Fri", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sat", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sun", showDay: false, startTime: "", endTime: "")], tags: [""], applicationInfo: ApplicationInfo(name: "", requireEmail: false, email: "", requirePhoneNumber: false, phoneNumber: "", questions: [AppQuestion(question: "", answer: "")], otherInfo: ""), jobDescription: ""))
   }
}
