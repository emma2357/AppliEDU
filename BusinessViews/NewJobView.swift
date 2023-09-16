//
//  NewJobView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI

// Page for creating a new job
struct NewJobView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment (\.presentationMode) var presentationMode
    
    @State var newJob: JobInfo = JobInfo(jobName: "", business: "", businessLocation: "", businessDescription: "", payRange: "", location: "", coordinates: ["0", "0"], minAge: "13", timeSchedule: [TimeSchedule(day: "Mon", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Tues", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Wed", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Thurs", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Fri", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sat", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sun", showDay: false, startTime: "", endTime: "")], tags: [""], applicationInfo: ApplicationInfo(name: "", requireEmail: false, email: "", requirePhoneNumber: false, phoneNumber: "", questions: [AppQuestion(question: "", answer: "")], otherInfo: "", resumeURL: ""), jobDescription: "")
    @State var pay = 0.0
    
    var jobOptions = JobOptions()
    var appInfo = AppInfo()
    
    var body: some View {
            ScrollView {
                Text("Create New Position")
                    .font(Font.custom(appInfo.font, size: appInfo.title))
                
                // all the customizable fields
                VStack(alignment: .leading) {
                    Text("POSITION NAME")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextField("Volunteer", text: $newJob.jobName)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                }.padding([.leading, .trailing, .top])
                 
                
                VStack(alignment: .leading) {
                    HStack {
                        Toggle("PAY", isOn: $newJob.hasPay)
                            .tint(appInfo.backgroundBlueColor)
                            .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    }
                    if(newJob.hasPay) {
                        TextField("$5.00", text: $newJob.payRange)
                            .padding()
                            .background{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                            }
                    }
                }.padding([.leading, .trailing])
                
                VStack(alignment: .leading) {
                    Text("LOCATION")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextField("17 Example St", text: $newJob.location)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                }.padding([.leading, .trailing])
                
                VStack(alignment: .leading) {
                    Text("MINIMUM AGE")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    Picker("", selection: $newJob.minAge) {
                        ForEach(jobOptions.getMinAge(age: 18), id: \.self) {
                            Text($0)
                                .accessibility(label: Text($0))
                                
                        }
                    }.frame(maxWidth: .infinity)
                        .accentColor(.black)
                }.padding([.leading, .trailing, .top])
                
                VStack(alignment: .leading) {
                    Text("ADD HOURS")
                        .padding([.leading, .trailing, .top])
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TimeView(newJob: $newJob, age: -1)
                }
                
                NavigationLink("Add Tags", destination: TagView(newJob: $newJob))
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: appInfo.maxWidth - 40)
                    .background{
                        appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                
                
                VStack(alignment: .leading) {
                    Text("A Short Description of the Job")
                    
                    TextEditor(text: $newJob.jobDescription)
                        .frame(height: 100)
                        .padding(5)
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                }.padding([.leading, .trailing])
                
                VStack {
                    //Button for creating/customizing the application for this job
                    NavigationLink("Customize Application", destination: CustomizeAppView(newJob: $newJob))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: appInfo.maxWidth - 40)
                        .background{
                            appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    
                    // submit job
                    Button(action: {
                        // after creating job, add new job to database
                        dataModel.user.getCoordinatesFromLocation(address: newJob.location, saveCoordinates: { lat, long in
                            newJob.coordinates = [lat, long]
                            dataModel.addJob(newJob)
                            presentationMode.wrappedValue.dismiss()
                        })
                    }){
                        Text("Submit")
                            .foregroundColor(appInfo.whiteAccent)
                            .padding()
                            .frame(width: appInfo.maxWidth - 40)
                            .background{
                                appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                    }
                }
            
        }.onAppear(perform: {
            // when view appears, set user-related job information (name of business, location, business descr.)
                newJob.business = dataModel.user.username
                newJob.businessLocation = dataModel.user.location
                newJob.businessDescription = dataModel.user.businessDescription
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(Font.custom(appInfo.font, size: appInfo.body))
    }
}
struct NewJobView_Previews: PreviewProvider {
    static var previews: some View {
        NewJobView()
            .environmentObject(DataModel(user: UserInfo(email: "example@gmail.com", username: "Emma Capaldi", userType: UserType.businessAccount, businessDescription: "We love to make coffee and also sell coffee and really we're great", location: "place street", coordinates: ["",""])))
    }
}
