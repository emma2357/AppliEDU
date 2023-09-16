//
//  BookmarksView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/21/23.
//

import SwiftUI

// Page that display all bookmarked jobs
struct BookmarksView: View {
    @EnvironmentObject var dataModel: DataModel
    @State var bookmarkCount = 0
    
    var appInfo = AppInfo()
    
    func increaseBookmarkCount() -> Void {
        bookmarkCount += 1
    }
    
    var body: some View {
        ScrollView {
            Text("Bookmarks")
                .font(Font.custom(appInfo.font, size: appInfo.title))
            ForEach(0..<dataModel.jobs.count, id: \.self){ i in
                if let studentJob = dataModel.studentJobs.first(where: {$0.jobID == dataModel.jobs[i].id}){
                    if(studentJob.bookmarked == true) {
                        CondensedStudentJobView(job: dataModel.jobs[i])
                            .onAppear{
                                increaseBookmarkCount()
                            }
                    }
                }
            }
            
            if (bookmarkCount == 0) {
                Spacer()
                    .frame(height: 20)
                Text("None Yet")
                    .font(Font.custom(appInfo.font, size: appInfo.body))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            bookmarkCount = 0
        }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView()
            .environmentObject(DataModel(user: UserInfo(email: "example@gmail.com", username: "Emma Capaldi", userType: UserType.studentAccount, age: "16", location: "6 Woodhaven Drive", coordinates: ["1", "2"])))
    }
}
