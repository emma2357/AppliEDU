//
//  ExpandedJobView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI

// Page that display all job related information
struct ExpandedJobView: View {
    var job: JobInfo
    var appInfo = AppInfo()
    
    var body: some View {
        VStack {
            VStack (alignment: .leading, spacing: 5) {
                Text("\(job.jobName)")
                    .font(Font.custom(appInfo.font, size: appInfo.title))
                    .padding([.leading, .trailing])
                
                    VStack(alignment: .leading) {
                        Text("\(job.business)")
                            .font(Font.custom(appInfo.font, size: appInfo.body))
                        Button(action: {
                            // if user clicks on link, take them to google maps directions
                            let url = URL(string: "comgooglemaps://?saddr=&daddr=\(job.coordinates[0]),\(job.coordinates[1])&directionsmode=driving")
                                if UIApplication.shared.canOpenURL(url!) {
                                      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                }
                                else{
                                      let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(job.coordinates[0]),\(job.coordinates[1])&directionsmode=driving")

                                       UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
                                }
                        }){
                            Text("_\(job.location)_")
                                .foregroundColor(appInfo.backgroundBlueColor)
                        }
                        Text("\(job.businessDescription)")
                    }
                    .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                        .padding([.leading, .trailing, .top])
                
                VStack(alignment: .leading) {
                    Text("PAY")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    Text("\(job.payRange)")
                }.padding([.leading, .trailing, .top])
                    
                VStack(alignment: .leading) {
                    Text("MIN AGE")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    Text("\(job.minAge)")
                        
                }.padding([.leading, .trailing, .top])
                
                VStack(alignment: .leading) {
                    Text("HOURS")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    ForEach(0 ..< 7, id: \.self) { i in
                        if(job.timeSchedule[i].showDay){
                            Text("\(job.timeSchedule[i].day.uppercased()): \(job.timeSchedule[i].startTime) - \(job.timeSchedule[i].endTime)")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing, .top])
                
                    VStack(alignment: .leading) {
                        Text("TAGS")
                            .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                        ForEach(1 ..< job.tags.count, id: \.self) { i in
                            HStack {
                                Text(" ➢ ")
                                    .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                                Text("\(job.tags[i])")
                                    .foregroundColor(.black)
                            }
                        }
                    }.padding([.leading, .trailing, .top])
                
                VStack (alignment: .leading) {
                    Text("ADDITIONAL INFORMATION")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    Text("\(job.jobDescription)")
                }
                .padding([.leading, .trailing, .top])
                
                Spacer()
                
                // take user to application page
                NavigationLink("Apply", destination: ApplicationView(job: job))
                    .foregroundColor(appInfo.whiteAccent)
                    .padding()
                    .frame(width: appInfo.maxWidth - 40)
                    .background{
                        appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .font(Font.custom(appInfo.font, size: appInfo.title2))
                    .padding([.leading, .trailing, .top])
            }
        }.font(Font.custom(appInfo.font, size: appInfo.body))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ExpandedJobView_Previews: PreviewProvider {
    static var previews: some View {
        ExpandedJobView(job: JobInfo(jobName: "Barista", business: "Starbucks", businessLocation: "17 other place st", businessDescription: "We make coffeeee :)", payRange: "10.00", location: "17 place st", coordinates: ["0", "0"], minAge: "13", timeSchedule: [TimeSchedule(day: "Mon", showDay: true, startTime: "10:30", endTime: "11:00"), TimeSchedule(day: "Tues", showDay: true, startTime: "11:00", endTime: "11:30"), TimeSchedule(day: "Wed", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Thurs", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Fri", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sat", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sun", showDay: false, startTime: "", endTime: "")], tags: ["", "Communication", "Coding"], applicationInfo: ApplicationInfo(name: "", requireEmail: false, email: "", requirePhoneNumber: false, phoneNumber: "", questions: [AppQuestion(question: "", answer: "")], otherInfo: "", resumeURL: ""), jobDescription: "Hey hello cool stuff"))
            .environmentObject(DataModel(user: UserInfo(email: "", username: "", userType: UserType.studentAccount, age: "", location: "6 Woodhaven Drive", coordinates: ["1", "2"])))
    }
}
