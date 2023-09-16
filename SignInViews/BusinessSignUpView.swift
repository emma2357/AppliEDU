//
//  BusinessSignUpView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn

// Page for businesses to sign up to the app
struct BusinessSignUpView: View {
    @EnvironmentObject var dataModel: DataModel
    @State var selection: String? = nil

    // var for google sign-in
    var user = GIDSignIn.sharedInstance.currentUser
    
    var appInfo = AppInfo()
    
    var body: some View {
        VStack {
            // once the new account is created, move to home screen
            NavigationLink(destination: BusinessAccountView(), tag: "BusinessAccount", selection: $selection) { EmptyView() } // [1]
            
            VStack {
                // profile picture from google account
                ProfilePictureView(url: user?.profile?.imageURL(withDimension: 200))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .cornerRadius(8)
                Text("_\(user?.profile?.email ?? "")_")
                    .padding()
                
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
                    
                    Text("ADDRESS (number, street, town)")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextField("17 place st, place st, andover", text: $dataModel.user.location)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                    
                    Text("DESCRIPTION")
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    TextEditor(text: $dataModel.user.businessDescription)
                        .frame(height: 100)
                        .padding(5)
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                }.padding([.leading, .trailing, .bottom])
            }
            // create account
            Button(action:{
                // cwhen the user submits, save info to database
                dataModel.user.getCoordinatesFromLocation(address: dataModel.user.location, saveCoordinates: { lat, long in
                    let newUserInfo = UserInfo(email: user?.profile?.email ?? "", username: dataModel.user.username, userType: UserType.businessAccount, businessDescription: dataModel.user.businessDescription, location: dataModel.user.location, coordinates: [lat, long])
                        dataModel.user = newUserInfo
                        dataModel.addUser(newUserInfo)
                        selection = "BusinessAccount"
                        })
            }){
                Text("Create Account")
                    .foregroundColor(appInfo.whiteAccent)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: appInfo.maxWidth - 40)
                    .background{
                        appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(Font.custom(appInfo.font, size: appInfo.body))
    }
}

struct BusinessSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessSignUpView()
            .environmentObject(DataModel(user: UserInfo(email: "example@gmail.com", username: "Emma Capaldi", userType: UserType.businessAccount, businessDescription: "We love to make coffee and also sell coffee and really we're great", location: "place street", coordinates: ["",""])))
    }
}
