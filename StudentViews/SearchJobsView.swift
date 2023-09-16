//
//  SearchJobsView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//
//

import SwiftUI 

// home page for student account view
struct SearchJobsView: View {
    @EnvironmentObject var dataModel: DataModel
    
    //formating hours
    func hourToDouble(_ hour: String) -> Double {
        return Double(hour.replacingOccurrences(of: ":", with: ".")) ?? 0.0
    }
    
    var jobOptions = JobOptions()
    var appInfo = AppInfo()
    
    // job settings that can be changed by filtering
    @State var jobSettings: JobInfo = JobInfo(jobName: "none", business: "none", businessLocation: "none", businessDescription: "none", payRange: "none", location: "none", coordinates: ["0", "0"], minAge: "none", timeSchedule: [TimeSchedule(day: "Mon", showDay: false, startTime: "0:00", endTime: "0:00"), TimeSchedule(day: "Tues", showDay: false, startTime: "0:00", endTime: "0:00"), TimeSchedule(day: "Wed", showDay: false, startTime: "0:00", endTime: "0:00"), TimeSchedule(day: "Thurs", showDay: false, startTime: "0:00", endTime: "0:00"), TimeSchedule(day: "Fri", showDay: false, startTime: "0:00", endTime: "0:00"), TimeSchedule(day: "Sat", showDay: false, startTime: "0:00", endTime: "0:00"), TimeSchedule(day: "Sun", showDay: false, startTime: "0:00", endTime: "0:00")], tags: [""], applicationInfo: ApplicationInfo(name: "", requireEmail: false, email: "", requirePhoneNumber: false, phoneNumber: "", questions: [AppQuestion(question: "", answer: "")], otherInfo: "", resumeURL: ""), jobDescription: "")
    
        func displayJob(i: Int) -> Bool {
            // check age and pay
            if((Int(dataModel.jobs[i].minAge) ?? 0 <= Int(jobSettings.minAge) ?? 0) && (Double(dataModel.jobs[i].payRange) ?? 0.0 >= Double(jobSettings.payRange) ?? 0.0)) {
    
                // check time schedule
                for j in (0 ..< 7) {
                    if ((dataModel.jobs[i].timeSchedule[j].showDay == true) && (jobSettings.timeSchedule[j].showDay == true)){
                        let jobStartTime = hourToDouble(dataModel.jobs[i].timeSchedule[j].startTime)
                        let settingsStartTime = hourToDouble(jobSettings.timeSchedule[j].startTime)
                        let jobEndTime = hourToDouble(dataModel.jobs[i].timeSchedule[j].endTime)
                        let settingsEndTime = hourToDouble(dataModel.jobs[i].timeSchedule[j].endTime)
    
                        if (Int(dataModel.user.age) ?? 0 <= 15){
                            if (!((jobStartTime <= settingsStartTime) && (jobStartTime <= 7.00) && (jobEndTime >= settingsEndTime) && (jobEndTime >= 21.00))) {
                                return false
                            }
                        } else if (Int(dataModel.user.age) ?? 0 <= 17){
                            if (!((jobStartTime <= settingsStartTime) && (jobStartTime <= 6.00) && (jobEndTime >= settingsEndTime) && (jobEndTime >= 22.00))) {
                                return false
                            }
                        }
                    }
                }
    
                // check tags
                for tag in jobSettings.tags {
                    if (!(dataModel.jobs[i].tags.contains(tag)) && tag != "") {
                        return false
                    }
                }
    
                // check pay (remove any strings that use the $ sign)
                let jobSettingsPay = jobSettings.payRange.replacingOccurrences(of: "$", with: "") // [1]
                let jobPay = dataModel.jobs[i].payRange.replacingOccurrences(of: "$", with: "")
                if (Double(jobSettingsPay) ?? 0.00 <= Double(jobPay) ?? 0.00) {
                    let jobLat = Double(dataModel.jobs[i].coordinates[0]) ?? 0
                    let jobLong = Double(dataModel.jobs[i].coordinates[1]) ?? 0
                    let userLat = Double(dataModel.user.coordinates[0]) ?? 0
                    let userLong = Double(dataModel.user.coordinates[1]) ?? 0
                    let xDiff =  (jobLat - userLat) * 69.0
                    let xDist = pow(xDiff, 2)
                    let yDiff = (jobLong - userLong) * 54.6
                    let yDist = pow(yDiff, 2)
                    let jobDistance = sqrt(xDist + yDist)
                    
                    if (jobDistance <= jobSettings.distance) {
                        // if fits all settings criteria, return true
                        return true
                    }
                    return false
                }
    
                return false
            }
            return false
        }
    
    var body: some View {
        VStack {
            HStack {
                Text("Search Positions")
                    .padding()
                    .font(Font.custom(appInfo.font, size: appInfo.title))
                
                Spacer()
                
                NavigationLink("Filter Positions", destination: FilterView(jobSettings: $jobSettings))
                    .foregroundColor(appInfo.whiteAccent)
                    .padding()
                    .background{
                        appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.trailing)
                    .font(Font.custom(appInfo.font, size: appInfo.title2))
            }
            ScrollView {
                ForEach(0..<dataModel.jobs.count, id: \.self){ i in
                    // filter in here for specific jobs
                    if (displayJob(i: i)) {
                        CondensedStudentJobView(job: dataModel.jobs[i])
                    }
                }
            }
        }
            .onAppear(perform: {
                // make sure age-related time restrictions are in place
                jobSettings.minAge = dataModel.user.age
                for i in 0..<7 {
                    if (Int(dataModel.user.age) ?? 13 <= 15){
                        jobSettings.timeSchedule[i].startTime = "7:00"
                        jobSettings.timeSchedule[i].endTime = "20:30"
                    } else if (Int(dataModel.user.age) ?? 13 <= 17) {
                        jobSettings.timeSchedule[i].startTime = "6:00"
                        jobSettings.timeSchedule[i].endTime = "21:30"
                    }
                }
            })
    }
}

struct SearchJobsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchJobsView()
            .environmentObject(DataModel(user: UserInfo(email: "", username: "", userType: UserType.studentAccount, age: "17", location: "6 Woodhaven Drive", coordinates: ["42", "-71.123"])))
    }
}
