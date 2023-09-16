//
//  SignUpView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 4/30/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn

// Page for creating a new account  
struct SignUpView: View {
    var appInfo = AppInfo()
    
    var body: some View {
        NavigationView {
            VStack {
                Image("BookStack")
                    .resizable()
                    .frame(width: 200, height: 200)
            
                VStack (alignment: .leading) {
                    Text("Welcome to")
                        .font(Font.custom(appInfo.font, size: appInfo.title + 10))
                    Text("AppliEDU")
                        .font(Font.custom(appInfo.font, size: appInfo.title + 25))
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Text("Continue As:")
                        .font(Font.custom(appInfo.font, size: appInfo.title2))
                    
                    // sign in as student
                    HStack {
                        Image(systemName: "graduationcap")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Spacer()
                            .frame(width: 20)
                        
                        NavigationLink("Student", destination: StudentSignUpView())
                            .font(Font.custom(appInfo.font, size: appInfo.title))
                    }
                    .frame(width: appInfo.maxWidth - 60)
                    .foregroundColor(appInfo.whiteAccent)
                    .padding()
                    .background{
                        appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    // sign in as organization
                    HStack {
                        Image(systemName: "house")
                            .resizable()
                            .frame(width: 30, height: 25)
                        
                        Spacer()
                            .frame(width: 20)
                        NavigationLink("Business", destination: BusinessSignUpView())
                            .font(Font.custom(appInfo.font, size: appInfo.title))
                    }
                    .frame(width: appInfo.maxWidth - 60)
                    .padding()
                    .foregroundColor(appInfo.whiteAccent)
                    .background{
                        appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(Font.custom(appInfo.font, size: appInfo.body))
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
