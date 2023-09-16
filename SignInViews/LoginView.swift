//
//  LoginView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn

// Google sign in page (first page users see when opening app)
struct LoginView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var appInfo = AppInfo()
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 60)
            Image("BookStack")
                .resizable()
                .frame(width: 200, height: 200)
            VStack (alignment: .leading) {
                Text("Welcome to")
                    .font(Font.custom(appInfo.font, size: appInfo.title + 10))
                    .padding(.leading)
                Text("AppliEDU")
                    .font(Font.custom(appInfo.font, size: appInfo.title + 25))
                    .padding(.leading)
                
                Spacer()
                    .frame(height: 20)
                
                Text("Making it easy for students to volunteer, intern, find jobs, and discover other opportunities that are perfect for them.")
                    .padding(.leading)
                    .font(Font.custom(appInfo.font, size: appInfo.body))
                
                Spacer()
                    .frame(height: 20)
                
                GoogleSignInButton()
                    .padding()
                    .onTapGesture {
                        dataModel.signIn()
                    }
            }
        }
    }
}

// View that pops up when users sign in with google
struct GoogleSignInButton: UIViewRepresentable {
    private var button = GIDSignInButton()
    
    func makeUIView(context: Context) -> GIDSignInButton {
        return button
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        
    }
}
