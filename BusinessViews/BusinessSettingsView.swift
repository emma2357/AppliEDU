//
//  BusinessSettingsView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI
import GoogleSignIn

// display user information and allow for editing 
struct BusinessSettingsView: View {
    @EnvironmentObject var dataModel: DataModel
    var user = GIDSignIn.sharedInstance.currentUser
    
    var appInfo = AppInfo()
    
    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .padding()
                    .font(Font.custom(appInfo.font, size: appInfo.title))
                Spacer()
            }
            
            // profile picture
            VStack {
                ProfilePictureView(url: user?.profile?.imageURL(withDimension: 200))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80, alignment: .center)
                    .cornerRadius(8)
                
                Text("_\(user?.profile?.email ?? "")_")
                
                Spacer()
                    .frame(height: 20)
                
                // textfields
                VStack(alignment: .leading) {
                        Text("BUSINESS NAME")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                        TextField("\(user?.profile?.name ?? "")", text: $dataModel.user.username)
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
                        
                    
                        Text("DESCRIPTION")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                        
                        TextEditor(text: $dataModel.user.businessDescription)
                            .frame(height: 100)
                            .border(Color(.white))
                            .padding(5)
                            .background{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                            }
                }.padding([.leading, .trailing, .bottom])
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

struct BusinessSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessSettingsView()
            .environmentObject(DataModel(user: UserInfo(email: "example@gmail.com", username: "Emma Capaldi", userType: UserType.businessAccount, businessDescription: "We love to make coffee and also sell coffee and really we're great", location: "place street",coordinates: ["",""])))
    }
}
