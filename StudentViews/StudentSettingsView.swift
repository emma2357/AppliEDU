//
//  StudentSettingsView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI
import GoogleSignIn

// Page that displays user information
struct StudentSettingsView: View {
    @EnvironmentObject var dataModel: DataModel
    @State var selection: String? = nil
    
    var user = GIDSignIn.sharedInstance.currentUser
    
    var appInfo = AppInfo()
    
    var body: some View {
        VStack {
            NavigationLink(destination: EditResumeView(), tag: "Resume", selection: $selection) { EmptyView() }
            
            HStack {
                Text("Settings")
                    .font(Font.custom(appInfo.font, size: appInfo.title))
                    .padding()
                Spacer()
            }
            
            // textfields to edit
            VStack {
                ProfilePictureView(url: user?.profile?.imageURL(withDimension: 200))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80, alignment: .center)
                    .cornerRadius(8)
                
                Text("_\(user?.profile?.email ?? "")_")
                
                Spacer()
                    .frame(height: 20)
                
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
                    
                    Text("LOCATION")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextField("19 Example St", text: $dataModel.user.location)
                .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                    }
                }.padding([.leading, .trailing, .bottom]) 
            }
            
            // Bring user to page for editing resume information
            Button(action: {
                // allow user to save changes
                selection = "Resume"
            }) {
                Text("Edit Resume Information")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: appInfo.maxWidth - 30)
                    .background{
                        appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    } 
            }
            
            Spacer()
            
            Button(action: {
                // allow user to save changes
                dataModel.user.getCoordinatesFromLocation(address: dataModel.user.location, saveCoordinates: { lat, long in
                    dataModel.user.coordinates = [lat, long]
                    dataModel.updateUser(dataModel.user)
                })
            }) {
                Text("Save New Settings")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: appInfo.maxWidth - 30)
                    .background{
                        appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }
            
            Button(action:
                    // sign out using google sign out
                    dataModel.signOut
            ) {
                Text("Sign Out")
                    .foregroundColor(appInfo.whiteAccent)
                    .padding()
                    .frame(width: appInfo.maxWidth - 30)
                    .background{
                        appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }
            
            Spacer()
                .frame(height: 20)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(Font.custom(appInfo.font, size: appInfo.body))
    }
}

struct StudentSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        StudentSettingsView()
            .environmentObject(DataModel(user: UserInfo(email: "example@gmail.com", username: "Emma Capaldi", userType: UserType.studentAccount, age: "16", location: "6 Woodhaven Drive", coordinates: ["1", "2"])))
    }
}
