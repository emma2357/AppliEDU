//
//  StudentSignUpResumeView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 8/11/23.
//

import SwiftUI

// Page for students to input resume information
struct StudentSignUpResumeView: View {
    @EnvironmentObject var dataModel: DataModel
    @State var selection1: String? = nil
    
    var email: String
    
    var appInfo = AppInfo()
    
    var body: some View {
        ScrollView {
            // when done, go to student account home page
            NavigationLink(destination: StudentAccountView(), tag: "StudentAccount", selection: $selection1) { EmptyView() }
            
            ResumeBuilderView(userInfo: $dataModel.user)
            
            // create account
            Button(action: {
                // when the account is created, save all information to firebase and to dataModel
                dataModel.user.getCoordinatesFromLocation(address: dataModel.user.location, saveCoordinates: {lat, long in
                    let newUserInfo = UserInfo(email: email, username: dataModel.user.username, userType: UserType.studentAccount, age: dataModel.user.age, location: dataModel.user.location, coordinates: [lat, long])
                    dataModel.addUser(newUserInfo)
                    dataModel.user = newUserInfo
                    selection1 = "StudentAccount"
                })
                
            }){
                Text("Create Account")
                    .foregroundColor(appInfo.whiteAccent)
                    .padding()
                    .frame(width: appInfo.maxWidth - 30)
                    .background{
                        appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(Font.custom(appInfo.font, size: appInfo.body))
            .onAppear(perform: {
            })
    }
}

struct StudentSignUpResumeView_Previews: PreviewProvider {
   static var previews: some View {
       StudentSignUpResumeView()
           .environmentObject(DataModel(user: UserInfo(email: "example@gmail.com", username: "Emma Capaldi", userType: UserType.studentAccount, age: "16", location: "6 Woodhaven Drive", coordinates: ["1", "2"])))
   }
}
