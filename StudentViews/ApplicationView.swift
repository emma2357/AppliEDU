//
//  ApplicationView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

// Page for user to fill out application
struct ApplicationView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment (\.presentationMode) var presentationMode
    
    @State var studentJob: StudentJobInfo = StudentJobInfo(jobID: "nil", userID: "nil", bookmarked: false, applicationProgress: ApplicationProgress.noApplication, application: ApplicationInfo(name: "", requireEmail: false, email: "", requirePhoneNumber: false, phoneNumber: "", questions: [AppQuestion(question: "", answer: "")], otherInfo: "", resumeURL: ""))
    @State var selection: String? = nil
    
    var job: JobInfo
    var appInfo = AppInfo()
    
    @State var openFile = false
    
    var body: some View {
        ScrollView {
            // different linked pages (creating a custom resume, conducting practice interview)
            NavigationLink(destination: CustomResumeView(job: job), tag: "CustomResume", selection: $selection) { EmptyView() }
            NavigationLink(destination: InterviewView(job: job), tag: "Interview", selection: $selection) { EmptyView() }
            Text("Application Form for \(job.jobName)")
                .font(Font.custom(appInfo.font, size: appInfo.title2))

            // textfields to fill out
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("NAME")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextField("John Smith", text: $studentJob.application.name)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                }.padding([.leading, .trailing, .top])
                
                if(studentJob.application.requireEmail){
                    VStack(alignment: .leading) {
                        Text("EMAIL")
                            .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                        TextField("example@gmail.com", text: $studentJob.application.email)
                            .padding()
                                .background{
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                                }
                    }.padding([.leading, .trailing])
                }
                
                if(studentJob.application.requirePhoneNumber){
                    VStack(alignment: .leading) {
                        Text("PHONE NUMBER")
                            .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                        TextField("123-456-7890", text: $studentJob.application.phoneNumber)
                            .padding()
                                .background{
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                                }

                    }.padding([.leading, .trailing])
                }
                
                Text("QUESTIONS")
                    .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    .padding()
                
                ForEach(0 ..< studentJob.application.questions.count, id: \.self) { i in
                    VStack (alignment: .leading) {
                        Text("\(i + 1). \(studentJob.application.questions[i].question)")
                        TextEditor(text: $studentJob.application.questions[i].answer)
                            .frame(height: 100)
                            .padding(5)
                            .background{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                            }
                    } .padding([.leading, .trailing, .bottom])
                    
                }
                
            }
            
            HStack {
                Button(action: {
                    selection = "CustomResume"
                }) {
                    Text("Create Custom Resume")
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: (appInfo.maxWidth - 30)/2 - 5)
                        .background{
                            appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                }
                
                // upload a custom pdf resume to application
                Button(action: {
                    openFile.toggle()
                    
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    
                    // File located on disk
                    let localFile = URL(string: "\(studentJob.application.resumeURL)")!
                    let riversRef = storageRef.child("\(studentJob.application.resumeURL)")
                    
                    // Upload the file to the path "docs/rivers.pdf"
                    let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { metadata, error in
                        guard let metadata = metadata else {
                            return
                        }
                        let size = metadata.size
                        storageRef.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                return
                            }
                        }
                    }
                }) {
                    Text("Upload Resume PDF")
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: (appInfo.maxWidth - 30)/2 - 5)
                        .background{
                            appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                }
            }
            
            VStack (alignment: .leading) {
                Text("ADDITIONAL INFORMATION")
                    .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                Text("\(studentJob.application.otherInfo)")
                    .frame(width: .infinity)
                    .multilineTextAlignment(.leading)
                    .padding([.top], 3)
                
            }
            .padding()
            
            // conduct a mock interview
            Button(action: {
                selection = "Interview"
            }) {
                Text("Mock Interview")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: appInfo.maxWidth - 30)
                    .background{
                        appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }
            
            Button(action: {
                // if only saving app, mark app as "in progess"
                studentJob.applicationProgress = ApplicationProgress.applicationInProgress
                dataModel.updateStudentJob(studentJob)
                
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: appInfo.maxWidth - 30)
                    .background{
                        appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }
            Button(action: {
                // if submitting application, mark app as "completed"
                studentJob.applicationProgress = ApplicationProgress.applicationCompleted
                dataModel.updateStudentJob(studentJob)
                
                presentationMode.wrappedValue.dismiss()
            }){
                Text("Submit")
                    .foregroundColor(appInfo.whiteAccent)
                    .padding()
                    .frame(width: appInfo.maxWidth - 30)
                    .background{
                        appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
            }
            // upload submitted pdf to Firebase (so organization can access)
        }.fileImporter( isPresented: $openFile, allowedContentTypes: [.pdf], allowsMultipleSelection: false, onCompletion: {
            (Result) in
            do{let fileURL = try Result.get()
                print(fileURL)
                studentJob.application.resumeURL = fileURL.first?.lastPathComponent ?? "file not available"
            }
            catch{
               print("error reading file \(error.localizedDescription)")
            }
            
        })
        .onAppear(perform: {
            // if job doesn't exist in database, add it
            if let studentJob = dataModel.studentJobs.first(where: {$0.jobID == job.id}) {
                self.studentJob = studentJob
            }else {
                // if it does exist, get information
                let newStudent = StudentJobInfo(jobID: job.id ?? "nil", userID: dataModel.user.id ?? "nil", bookmarked: false, applicationProgress: ApplicationProgress.noApplication, application: job.applicationInfo)
                studentJob = newStudent
                dataModel.addStudentJob(newStudent)
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(Font.custom(appInfo.font, size: appInfo.body))
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationView(job: JobInfo(jobName: "Barista", business: "Starbucks", businessLocation: "17 other place st", businessDescription: "We make coffeeee :)", payRange: "10.00", location: "17 place st", coordinates: ["0", "0"], minAge: "13", timeSchedule: [TimeSchedule(day: "Mon", showDay: true, startTime: "10:30", endTime: "11:00"), TimeSchedule(day: "Tues", showDay: true, startTime: "11:00", endTime: "11:30"), TimeSchedule(day: "Wed", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Thurs", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Fri", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sat", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sun", showDay: false, startTime: "", endTime: "")], tags: ["", "Communication", "Coding"], applicationInfo: ApplicationInfo(name: "", requireEmail: true, email: "", requirePhoneNumber: true, phoneNumber: "", questions: [AppQuestion(question: "Hey how's it going", answer: "")], otherInfo: "this is our application!", resumeURL: ""), jobDescription: "Hey hello cool stuff"))
            .environmentObject(DataModel(user: UserInfo(email: "", username: "", userType: UserType.studentAccount, age: "", location: "6 Woodhaven Drive", coordinates: ["1", "2"])))
    }
}
