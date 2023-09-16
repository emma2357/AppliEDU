//
//  TagView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/24/23.
//

import SwiftUI

// Subview for selecting tags used by business and student views 
struct TagView: View {
    @Binding var newJob: JobInfo 
    @Environment (\.presentationMode) var presentationMode
    var jobOptions = JobOptions()
    var appInfo = AppInfo()
    
    var body: some View {
        ScrollView {
            Text("Select Tags:")
            ForEach(jobOptions.tagOptions, id: \.self) { tag in
                Button(action: {
                    if (newJob.tags.contains(tag)) {
                        newJob.tags.removeAll(where: {$0 == tag})
                    }
                    else {
                        newJob.tags.append(tag)
                    }
                }) {
                    HStack {
                        Text(tag)
                        Spacer()
                        if (newJob.tags.contains(tag)) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .foregroundColor(.black)
                .padding()
                .frame(width: appInfo.maxWidth - 40)
                .background{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(appInfo.accentBlueColor, lineWidth: 3.5)
                }
                .padding([.leading, .trailing])
            }

            //save selected tags and exit page
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                Text("Submit")
                    .foregroundColor(appInfo.whiteAccent)
                    .padding()
                    .frame(width: appInfo.maxWidth - 40)
                    .background{
                        appInfo.backgroundBlueColor.clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(Font.custom(appInfo.font, size: appInfo.body))
    }
}

struct TagView_Previews: PreviewProvider {
   static var previews: some View {
       TagView()
   }
}
