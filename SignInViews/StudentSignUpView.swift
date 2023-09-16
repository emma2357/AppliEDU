//
//  StudentSignUpView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn

// First page when user signs up as a student
struct StudentSignUpView: View {
    @EnvironmentObject var dataModel: DataModel
    @State var selection: String? = nil
    var user = GIDSignIn.sharedInstance.currentUser
    
    var appInfo = AppInfo()
    
    var body: some View {
        VStack {
            // once the new account is created, move to home screen
            NavigationLink(destination: StudentSignUpResumeView(email: user?.profile?.email ?? ""), tag: "ResumeView", selection: $selection) { EmptyView() }
            
            VStack {
                // profile picture
                ProfilePictureView(url: user?.profile?.imageURL(withDimension: 200))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .cornerRadius(8)
                Text("_\(user?.profile?.email ?? "")_")
                    .padding()
                
                // textfields to edit
                VStack(alignment: .leading) {
                    Text("USERNAME")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextField("\(user?.profile?.name ?? "")", text: $dataModel.user.username)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5) 
                        }
                    
                    Text("AGE")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextField("13", text: $dataModel.user.age)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                    
                    Text("ADDRESS (number, street, town)")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextField("17 Example Dr, Town", text: $dataModel.user.location)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                    
                }.padding([.leading, .trailing, .bottom])
            }
            
            // take user to resume customization page
            Button(action: {
                selection = "ResumeView"
            }){
                Text("Continue")
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

struct StudentSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        StudentSignUpView()
            .environmentObject(DataModel(user: UserInfo(email: "example@gmail.com", username: "Emma Capaldi", userType: UserType.studentAccount, age: "16", location: "6 Woodhaven Drive", coordinates: ["1", "2"])))
    }
}
