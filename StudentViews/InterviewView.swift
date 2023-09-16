//
//  InterviewView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 8/12/23.
//

import SwiftUI
import Combine

// Page that displays conversation between user and chatGPT (simulating an interview)
struct InterviewView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment (\.presentationMode) var presentationMode
    var job: JobInfo
    
    var appInfo = AppInfo()
    
    @State var chatMessages: [ChatMessage] = []
    @State var gptQuestions: [String] = []
    @State var message: String = ""
    @State var userResponse: String = ""
    
    
    @State var questionCounter = 0
    
    let openAIService = OpenAIService()
    @State var isLoading: Bool = true

    @State var lastMessageID: String = ""

    @State var cancellables = Set<AnyCancellable>()

    // send message to chatGPT and get reply
    func sendMessage (){
        isLoading = true
        guard message != "" else {return}
        
        let myMessage = ChatMessage(id: UUID().uuidString, content: "loading...", createdAt: Date(), sender: .me)
        
        openAIService.sendMessage(message: message).sink { completion in
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {return}
            let chatGPTMessage = ChatMessage(id: response.id, content: textResponse, createdAt: Date(), sender: .chatGPT)
            
            gptQuestions = chatGPTMessage.content.split(separator: "\n").map { String($0) }
            
            chatMessages.append(ChatMessage(id: response.id, content: gptQuestions[0], createdAt: Date(), sender: .chatGPT))
            isLoading = false
            print(chatGPTMessage)
            lastMessageID = chatGPTMessage.id
        }
        .store(in: &cancellables)
            
        message = ""
    }
    
    // get response from chatGPT and format it in a way that can be read back to user
    func sendResponseMessage (){
        isLoading = true
        guard message != "" else {return}
        
        let myMessage = ChatMessage(id: UUID().uuidString, content: userResponse, createdAt: Date(), sender: .me)
        chatMessages.append(myMessage)
        lastMessageID = myMessage.id
        print(message)
        userResponse = ""
        
        openAIService.sendMessage(message: message).sink { completion in
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {return}
            let chatGPTMessage = ChatMessage(id: response.id, content: textResponse, createdAt: Date(), sender: .chatGPT)

            chatMessages.append(chatGPTMessage)
            print(chatGPTMessage)
            lastMessageID = chatGPTMessage.id
            
            if (questionCounter < 10){
                questionCounter += 1
                chatMessages.append(ChatMessage(id: UUID().uuidString, content: gptQuestions[questionCounter], createdAt: Date(), sender: .chatGPT))
            }
            isLoading = false
        }
        .store(in: &cancellables)
            
        message = ""
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Mock Interview")
                    .font(Font.custom(appInfo.font, size: appInfo.title))
                    .padding()
                
                Spacer()
                
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
            
            ScrollViewReader { proxy in
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVStack {
                                    ForEach(chatMessages, id: \.id) { message in
                                    MessageView(message: message)
                                    }
                                }
                                
                            }
                            .onChange(of: self.lastMessageID) { id in
                                withAnimation{
                                    proxy.scrollTo(id, anchor: .bottom)
                                }
                            }
            }.padding()
                        // show conversation, display "loading" if message has not been recieved yet
                        HStack {
                            if (isLoading) {
                                Text("loading ...")
                            } else {
                                TextField("Enter a message", text: $userResponse) {}
                                    .padding()
                                    .cornerRadius(12)
                                Button{
                                    // format message prompt to send to AI
                                    message = "An interviewer asked me '\(gptQuestions[questionCounter])'. I responded '\(userResponse)'. Please provide an analysis of my response and advice."
                                    sendResponseMessage()
                                    
                                } label: {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundColor(appInfo.backgroundBlueColor)
                                        .padding(.horizontal)
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(Font.custom(appInfo.font, size: appInfo.body))
            .onAppear(perform: {
                // format message prompt to send to AI
                message = "For the rest of this conversation, you are an interviewer talking to a high school candidate who is applying for a position as \(job.jobName). This position is described as follows: \n \(job.jobDescription)\n The student has given you this information about themselves:\n Their name is \(dataModel.user.resumeInfo.fullName). \n They go to school at \(dataModel.user.resumeInfo.schoolName) and their GPA is \(dataModel.user.resumeInfo.gpa).\nWhen asked to write about their past jobs and volunteering experiences, they wrote the following:\n \(dataModel.user.resumeInfo.jobsVolunteering) \n When asked to write about clubs and other extracurriculars they participated in, they wrote the following:\n \(dataModel.user.resumeInfo.clubs)\n When asked to write about their hobbies and interests, they wrote the following:\n \(dataModel.user.resumeInfo.hobbies) \n Give me an enumerated list of 10 questions an interviewer would ask to John Smith. Do not include anything except the questions, and do not include any form of introduction."
                
                sendMessage()
        })
    }
}

// Create message subview
struct MessageView: View {
    var message: ChatMessage
    var appInfo = AppInfo()
    var body: some View {
            HStack{
                // color coded by sender
                    if message.sender == .me{Spacer()}
                    Text(message.content)
                    .foregroundColor(message.sender == .me ? appInfo.whiteAccent : .black)
                        .padding()
                        .background(message.sender == .me ? appInfo.backgroundBlueColor : appInfo.accentBlueColor)
                        .cornerRadius(24)
                    if message.sender == .chatGPT{Spacer()}
            }
        }
}

struct InterviewView_Previews: PreviewProvider {
    static var previews: some View {
        InterviewView(job: JobInfo(jobName: "Barista", business: "Starbucks", businessLocation: "17 other place st", businessDescription: "We make coffeeee :)", payRange: "10.00", location: "17 place st", coordinates: ["0", "0"], minAge: "13", timeSchedule: [TimeSchedule(day: "Mon", showDay: true, startTime: "10:30", endTime: "11:00"), TimeSchedule(day: "Tues", showDay: true, startTime: "11:00", endTime: "11:30"), TimeSchedule(day: "Wed", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Thurs", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Fri", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sat", showDay: false, startTime: "", endTime: ""), TimeSchedule(day: "Sun", showDay: false, startTime: "", endTime: "")], tags: ["", "Communication", "Coding"], applicationInfo: ApplicationInfo(name: "", requireEmail: true, email: "", requirePhoneNumber: true, phoneNumber: "", questions: [AppQuestion(question: "Hey how's it going", answer: "")], otherInfo: "this is our application!", resumeURL: ""), jobDescription: "Hey hello cool stuff"))
            .environmentObject(DataModel(user: UserInfo(email: "", username: "", userType: UserType.studentAccount, age: "", location: "6 Woodhaven Drive", coordinates: ["1", "2"])))
    }
}
