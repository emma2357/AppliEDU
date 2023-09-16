//
//  ResourcesView.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 8/11/23.
//

import SwiftUI

// Page that displays some links to other resources related to applying to jobs
struct ResourcesView: View {
    var appInfo = AppInfo()
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                Text("Resources")
                    .font(Font.custom(appInfo.font, size: appInfo.title))
                    .padding(.bottom, 3)
                Text("A collection of websites and videos that can help you learn how to write and format a resume, conduct an interview, and more!")
                    .font(Font.custom(appInfo.font, size: appInfo.smallBody))
                    .padding(.bottom)
                
                Group{
                    Text("RESUME")
                        .font(Font.custom(appInfo.font, size: appInfo.body))
                        .padding(.bottom, 3)
                
                    HStack {
                        Text("➢")
                        Link("High School Resume Step-by-Step", destination: URL(string: "https://www.cappex.com/articles/applications/high-school-resume-step-by-step")!)
                            .padding(.bottom, 1)
                    }
                    HStack {
                        Text("➢")
                        Link("Writing a Resume that Stands Out", destination: URL(string: "https://www.asvabprogram.com/media-center-article/64")!)
                            .padding(.bottom, 1)
                    }
                    HStack {
                        Text("➢")
                        Link("High School Resume Tips", destination: URL(string: "https://www.indeed.com/career-advice/resumes-cover-letters/high-school-resume-tips")!)
                            .padding(.bottom, 1)
                    }
                    HStack {
                        Text("➢")
                        Link("Resumes: A How-To Guide", destination: URL(string: "https://novoresume.com/career-blog/high-school-resume")!)
                            .padding(.bottom, 1)
                    }
                }
                
                Group {
                    Text("INTERVIEW")
                        .font(Font.custom(appInfo.font, size: appInfo.body))
                        .padding(.top, 8)
                        .padding(.bottom, 3)
                    HStack {
                        Text("➢")
                        Link("11 Jobs Interview Tips", destination: URL(string: "https://www.indeed.com/career-advice/interviewing/interview-tips-for-teens")!)
                            .padding(.bottom, 1)
                    }
                    HStack {
                        Text("➢")
                        Link("Job Interview Advice for High Schoolers", destination: URL(string: "https://www.grandshake.co/post/6-tips-for-high-school-students-to-top-job-interview")!)
                            .padding(.bottom, 1)
                    }
                    HStack {
                        Text("➢")
                        Link("Job Interview Tips for Teens", destination: URL(string: "https://www.themuse.com/advice/job-interview-tips-for-teens")!)
                            .padding(.bottom, 1)
                    }
                    HStack {
                        Text("➢")
                        Link("Mastering the Art of the Interview", destination: URL(string: "https://www.youtube.com/watch?v=ppf9j8x0LA8")!)
                            .padding(.bottom, 1)
                    }
                    
                }
            }
        }.padding([.leading, .trailing])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(Font.custom(appInfo.font, size: appInfo.body))
    }
}

struct ResourcesView_Previews: PreviewProvider {
    static var previews: some View {
        ResourcesView()
    }
}
