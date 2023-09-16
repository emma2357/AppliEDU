//
//  CustomizeAppView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI

// Page for customizing application for a particular job
struct CustomizeAppView: View {
    @Environment (\.presentationMode) var presentationMode
    @Binding var newJob: JobInfo
    
    var appInfo = AppInfo()
    
    var body: some View {
        ScrollView {
            // Specify what contact information to ask for
            VStack(alignment: .leading) {
                Text("CONTACT INFORMATION")
                    .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                
                HStack {
                    Toggle("Require Email", isOn: $newJob.applicationInfo.requireEmail)
                        .tint(appInfo.backgroundBlueColor)
                }
                
                HStack {
                    Toggle("Require Phone Number", isOn: $newJob.applicationInfo.requirePhoneNumber)
                        .tint(appInfo.backgroundBlueColor)
                }
                
                
                Spacer()
                    .frame(height: 30)
                
                Text("QUESTIONS")
                    .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                VStack {
                    ForEach(0 ..< newJob.applicationInfo.questions.count, id: \.self) { i in
                        TextField("question", text: $newJob.applicationInfo.questions[i].question)
                            .padding()
                            .background{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                            }
                    }
                    
                    // create another editable question
                    Button(action: {
                        newJob.applicationInfo.questions.append(AppQuestion(question: "", answer: ""))
                    }) {
                        Text("Add Question")
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: appInfo.maxWidth - 30)
                            .background{
                                appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                    }
                }
                
                Spacer()
                    .frame(height: 30)
                
                VStack(alignment: .leading) {
                    Text("ADDITIONAL INFORMATION")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextEditor(text: $newJob.applicationInfo.otherInfo)
                        .frame(height: 100)
                        .padding(5)
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                }
                
            }.padding([.leading, .trailing])
        
        Spacer()
            .frame(height: 30)
        
        // submit customized application
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Submit")
                .foregroundColor(appInfo.whiteAccent)
                .padding()
                .frame(width: appInfo.maxWidth - 30)
                .background{
                    appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                }
        }
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(Font.custom(appInfo.font, size: appInfo.body))
    }
}

struct CustomizeAppView_Previews: PreviewProvider {
   static var previews: some View {
       CustomizeAppView()
   }
}
