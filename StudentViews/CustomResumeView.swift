//
//  CustomResumeView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 8/12/23.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

// Page that gets custom formatted resume from chatGPT
struct CustomResumeView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment (\.presentationMode) var presentationMode
    var job: JobInfo
    
    var appInfo = AppInfo()
    
     let pastboard = UIPasteboard.general
     
    // chat GPT code
    @State var chatMessages: ChatMessage = ChatMessage(id: UUID().uuidString, content: "Loading...", createdAt: Date(), sender: .me)
      @State var message: String = ""
      let openAIService = OpenAIService()
      var isLoading: Bool = OpenAIService().isLoading

      @State var lastMessageID: String = ""

    @State var cancellables = Set<AnyCancellable>()

    // send message to chatGPT and get reply
    func sendMessage (){
        guard message != "" else {return}

        openAIService.sendMessage(message: message).sink { completion in
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {return}
            let chatGPTMessage = ChatMessage(id: response.id, content: textResponse, createdAt: Date(), sender: .chatGPT)

            chatMessages = chatGPTMessage
            print(chatGPTMessage)
            lastMessageID = chatGPTMessage.id
        }
        .store(in: &cancellables)

        message = ""
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Custom Resume")
                    .font(Font.custom(appInfo.font, size: appInfo.title))
                    .padding()
                
                Spacer()
                
                // copy text to clipboard to paste in a docs
                Button {
                    pastboard.string = "\(chatMessages.content)"
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                        .padding()
                        .foregroundColor(.white)
                        .background{
                            appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                }
                
                // leave page
                Button{
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Image(systemName: "xmark.square")
                        .resizable()
                        .foregroundColor(appInfo.backgroundBlueColor)
                        .frame(width: 40, height: 40)
                        .padding()
                }
            }
            
            // display reply from chatGPT
            Text("\(chatMessages.content)")
                .padding([.leading, .trailing])
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(Font.custom(appInfo.font, size: appInfo.body))
            .onAppear(perform: {
                // create a message to send to chatGPT
                var contactInfo: String {
                    var string = ""
                    if (dataModel.user.resumeInfo.showPhoneNumber) {
                        string.append("Their phone number is \(dataModel.user.resumeInfo.phoneNumber)")
                    }
                    if (dataModel.user.resumeInfo.showEmail) {
                        string.append("Their email is \(dataModel.user.resumeInfo.email)")
                    }
                    return string
                }
                message = "You are a human resources specialist helping a student create a resume for \(job.jobName). Create a professional resume that is tailored to the job. Leave out any extraneous details that the student provided. \n The job is described as follows: \n \(job.jobDescription). \n The student has given you this information about themselves:\n Their name is \(dataModel.user.resumeInfo.fullName). \n \(contactInfo)\n They go to school at \(dataModel.user.resumeInfo.schoolName) and their GPA is \(dataModel.user.resumeInfo.gpa).\n When asked to write about their past jobs and volunteering experiences, they wrote the following:\n \(dataModel.user.resumeInfo.jobsVolunteering) \n When asked to write about clubs and other extracurriculars they participated in, they wrote the following:\n \(dataModel.user.resumeInfo.clubs)\n When asked to write about their hobbies and interests, they wrote the following:\n \(dataModel.user.resumeInfo.hobbies)"
                
                sendMessage()
        })
    }
}

struct CustomResumeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomResumeView(job: JobInfo(jobName: "Barista", business: "Starbucks", businessLocation: "17 other place st", businessDescription: "We make coffeeee :)", payRange: "10.00", location: "17 place st", coordinates: ["0", "0"], minAge: "13", timeSchedule: [TimeSchedule(day: "Mon", showDay: true, startTime: "10:30", endTime: "11:00"), TimeSchedule(day: "Tues", showDay: true, startTime: "11:00", endTime: "11:30"), TimeSchedule(day: "Wed", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Thurs", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Fri", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sat", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sun", showDay: false, startTime: "", endTime: "")], tags: ["", "Communication", "Coding"], applicationInfo: ApplicationInfo(name: "", requireEmail: true, email: "", requirePhoneNumber: true, phoneNumber: "", questions: [AppQuestion(question: "Hey how's it going", answer: "")], otherInfo: "this is our application!", resumeURL: ""), jobDescription: "Hey hello cool stuff"))
            .environmentObject(DataModel(user: UserInfo(email: "", username: "", userType: UserType.studentAccount, age: "", location: "6 Woodhaven Drive", coordinates: ["1", "2"])))
    }
}
