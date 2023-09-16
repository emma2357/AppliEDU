//
//  ResumeBuilderView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 8/11/23.
//

import SwiftUI
import Combine

// Page for editing resume builder information
struct ResumeBuilderView: View {
    @Binding var userInfo: UserInfo
    
    var appInfo = AppInfo()
    
    var body: some View {
        ScrollView {
            Text("Resume Builder")
                .font(Font.custom(appInfo.font, size: appInfo.title))
                .padding(.bottom, 3)
            Text("This information can be used later to help you create a unique resume for each job you apply to! Make sure to be specific and include names and dates when writing about your past experiences.")
                .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                .padding(.bottom)
            
            // editable text fields
            VStack(alignment: .leading){
                Text("FULL NAME")
                    .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                TextField("John Smith", text: $userInfo.resumeInfo.fullName)
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                    }
                
                Text("CONTACT INFO")
                    .font(Font.custom(appInfo.font, size: appInfo.body))
                    .padding(.top)
                    .padding(.bottom, 3)
                
                Text("EMAIL")
                    .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                TextField("Email", text: $userInfo.resumeInfo.email)
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                    }
                Text("PHONE NUMBER")
                    .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                TextField("Phone Number", text: $userInfo.resumeInfo.phoneNumber)
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                    }
                
                Group {
                    Text("EDUCATION")
                        .font(Font.custom(appInfo.font, size: appInfo.body))
                        .padding(.top)
                        .padding(.bottom, 3)
                    
                    Text("SCHOOL NAME")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextField("Andover High School", text: $userInfo.resumeInfo.schoolName)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                    
                    Text("GPA")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextField("3.5", text: $userInfo.resumeInfo.gpa)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                }
                
                Group {
                    Text("FREE RESPONSE")
                        .font(Font.custom(appInfo.font, size: appInfo.body))
                        .padding(.top)
                        .padding(.bottom, 3)
                    
                    VStack (alignment: .leading) {
                        Text("Write about your past jobs and volunteering experiences, if any:")
                            .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                            .frame(width: appInfo.maxWidth - 100)
                            .fixedSize(horizontal: false, vertical: true)
                        TextEditor(text: $userInfo.resumeInfo.jobsVolunteering)
                            .frame(height: 100)
                            .padding(5)
                            .background{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                            }
                    }
                        .padding(.bottom,5)
                    
                    VStack (alignment: .leading) {
                        Text("Write about any clubs and other extracurriculars you participate in, if any:")
                            .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                            .frame(width: appInfo.maxWidth - 100)
                            .fixedSize(horizontal: false, vertical: true)
                        TextEditor(text: $userInfo.resumeInfo.clubs)
                            .frame(height: 100)
                            .padding(5)
                            .background{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                            }
                    }
                        .padding(.bottom,5)
                    
                    VStack (alignment: .leading) {
                        Text("Write about your interests and hobbies:")
                            .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                            .frame(width: appInfo.maxWidth - 100)
                            .fixedSize(horizontal: false, vertical: true)
                        TextEditor(text: $userInfo.resumeInfo.hobbies)
                            .frame(height: 100)
                            .padding(5)
                            .background{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                            }
                    }
                        .padding(.bottom,5)
                }
        }.padding([.leading, .trailing, .bottom])
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(Font.custom(appInfo.font, size: appInfo.body))
}
}

struct ResumeBuilderView_Previews: PreviewProvider {
   static var previews: some View {
        ResumeBuilderView()
            .environmentObject(DataModel(user: UserInfo(email: "example@gmail.com", username: "Emma Capaldi", userType: UserType.businessAccount, businessDescription: "We love to make coffee and also sell coffee and really we're great", location: "place street",coordinates: ["",""])))
   }
}
