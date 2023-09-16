//
//  EditResumeView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 8/11/23.
//

import SwiftUI

// View for editing resume information from settings
struct EditResumeView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment (\.presentationMode) var presentationMode
    var appInfo = AppInfo()
    var body: some View {
        ScrollView {

            ResumeBuilderView(userInfo: $dataModel.user)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                Text("Save Changes")
                    .foregroundColor(appInfo.whiteAccent)
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

struct EditResumeView_Previews: PreviewProvider {
   static var previews: some View {
       EditResumeView()
   }
}
