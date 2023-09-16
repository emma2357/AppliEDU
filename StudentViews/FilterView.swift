//
//  FilterView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI
import CoreLocation

// Page for editing filter settings view
struct FilterView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment (\.presentationMode) var presentationMode
    
    @State var pay = 0.0
    //save job settings as a JobInfo struct, since information stored is the same
    @Binding var jobSettings: JobInfo
    
    var jobOptions = JobOptions()
    var appInfo = AppInfo()
    
    var body: some View {
        ScrollView {
            Text("Filter By")
                .font(Font.custom(appInfo.font, size: appInfo.title))
            
            VStack (alignment: .leading) {
                HStack {
                    Toggle("MAX AGE", isOn: $jobSettings.hasMinAge)
                        .tint(appInfo.backgroundBlueColor)
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                }
                if (jobSettings.hasMinAge) {
                    Picker("", selection: $jobSettings.minAge) {
                        ForEach(jobOptions.getMinAge(age: Int(dataModel.user.age) ?? 13), id: \.self) {
                            Text($0)
                                .accessibility(label: Text($0))
                        }
                    }.accentColor(.black)
                }
            }.padding([.leading, .trailing])
            
            VStack (alignment: .leading) {
                HStack {
                    Toggle("PAY", isOn: $jobSettings.hasPay)
                        .tint(appInfo.backgroundBlueColor)
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                }
                if(jobSettings.hasPay) {
                    TextField("$5.00", text: $jobSettings.payRange)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(appInfo.accentBlueColor, lineWidth: 2.5)
                        }
                }
            }.padding([.leading, .trailing])
            
            VStack (alignment: .leading) {
                HStack {
                    Toggle("LOCATION", isOn: $jobSettings.hasLocation)
                        .tint(appInfo.backgroundBlueColor)
                        .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                }
                if(jobSettings.hasLocation) {
                    HStack {
                        Slider(value: $jobSettings.distance, in: 5...25, step: 5)
                            .accentColor(appInfo.backgroundBlueColor)
                        Text("\(String(format: "%.0f", jobSettings.distance)) miles")
                    }.padding([.leading, .trailing])
                }
            }.padding([.leading, .trailing])
            
            
            VStack (alignment: .leading) {
                Text("HOURS")
                    .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    .padding([.leading, .trailing])
                TimeView(newJob: $jobSettings, age: Int(dataModel.user.age) ?? 0)
            }
            
            NavigationLink("Tags", destination: TagView(newJob: $jobSettings))
                .foregroundColor(.black)
                .padding()
                .frame(width: appInfo.maxWidth - 40)
                .background{
                    appInfo.accentBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                }
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Filter Settings")
                    .foregroundColor(appInfo.whiteAccent)
                    .padding()
                    .frame(width: appInfo.maxWidth - 40)
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

struct FilterView_Previews: PreviewProvider {
   static var previews: some View {
       FilterView()
           .environmentObject(DataModel(user: UserInfo(email: "example@gmail.com", username: "Emma Capaldi", userType: UserType.studentAccount, age: "16")))
   }
}
