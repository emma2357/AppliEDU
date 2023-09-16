//
//  ExpandedStudentAppView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI
import FirebaseStorage

// Display application info in an expanted format 
struct ExpandedStudentAppView: View {
    var application: ApplicationInfo
    var appInfo = AppInfo()
    
    var body: some View {
        VStack(alignment: .leading) {
                    Text("Application of \(application.name)")
                .padding()
                    .background{
                        Color(.white).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding([.leading, .trailing])
                    .font(Font.custom(appInfo.font, size: appInfo.title2))
                
            VStack(alignment: .leading) {
                if(application.requireEmail){
                    Text("EMAIL")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    Text("\(application.email)")
                        .padding(.bottom)
                }
                
                if(application.requirePhoneNumber){
                    Text("PHONE NUMBER")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    Text("\(application.phoneNumber)")
                        .padding(.bottom)
                }
                
                ForEach(0 ..< application.questions.count, id: \.self) { i in
                        Text("\(application.questions[i].question)")
                        .font(Font.custom(appInfo.font, size: appInfo.body))
                        Text("\(application.questions[i].answer)")
                        .padding(.bottom)
                }

                // download student's resume pdf 
                Button(action: {
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let pdfRef = storageRef.child("\(application.resumeURL)")
                    
                    // Create local filesystem URL
                    let localURL = URL(string: "user/Documents/\(application.resumeURL)")!
                    
                    // Download to the local filesystem
                    let downloadTask = pdfRef.write(toFile: localURL)
                }) {
                    Text("Download Resume PDF")
                        .foregroundColor(appInfo.whiteAccent)
                        .padding()
                        .frame(width: appInfo.maxWidth - 40)
                        .background{
                            appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                }
                Spacer()
            }.padding([.leading, .trailing])
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background((Color.white))
            .font(Font.custom(appInfo.font, size: appInfo.body))
    }
}

struct ExpandedStudentAppView_Previews: PreviewProvider {
    static var previews: some View {
        ExpandedStudentAppView(application: ApplicationInfo(name: "Emma Capaldi", requireEmail: true, email: "example@gmail.com", requirePhoneNumber: true, phoneNumber: "123-456-7890", questions: [AppQuestion(question: "How much coffee?", answer: "1000")], otherInfo: "come on time please", resumeURL: ""))
    }
}
