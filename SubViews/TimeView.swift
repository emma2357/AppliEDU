//
//  TimeView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/24/23.
//

import SwiftUI

// Subview for selecting times used by business and student views
struct TimeView: View {
    @Binding var newJob: JobInfo
    var age: Int
    var jobOptions = JobOptions()
    var appInfo = AppInfo()
    
    var body: some View {
        VStack {
            // create new picker for each day of the week
            ForEach(0 ..< 7){ i in
                VStack(alignment: .leading) {
                    Button(action: {
                        newJob.timeSchedule[i].showDay.toggle()
                    }) {
                        Text("\(newJob.timeSchedule[i].day.uppercased())")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                    
                    if(newJob.timeSchedule[i].showDay){
                        HStack {
                            Text("STARTS:")
                                .font(Font.custom(appInfo.font, size: appInfo.smallBody))

                            // pick a time from available time slots
                            Picker("Appearance", selection: $newJob.timeSchedule[i].startTime) {
                                ForEach(jobOptions.getHourRange(age: age), id: \.self) {
                                    Text("\($0)")
                                        .tag("\($0)")
                                }
                            }
                            .pickerStyle(.wheel)
                        
                            Text("ENDS:")
                                .font(Font.custom(appInfo.font, size: appInfo.smallBody))

                            // pick a time from available time slots
                            Picker("Appearance", selection: $newJob.timeSchedule[i].endTime) {
                                ForEach(jobOptions.getHourRange(age: age), id: \.self) {
                                    Text("\($0)")
                                        .tag("\($0)")
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                        .frame(height: 100)
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//struct TimeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeView()
//    }
//}
