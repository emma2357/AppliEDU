//
//  DataModelInfo.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 5/24/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import GoogleSignIn
import SwiftUI

// data model for getting information from and saving information to firebase
class DataModel: ObservableObject {
    @Published var user: UserInfo
    @Published var jobs: [JobInfo] = [JobInfo]()
    @Published var studentJobs: [StudentJobInfo] = [StudentJobInfo]()
    
    var db = Firestore.firestore()
    
    init(user: UserInfo) {
        self.user = user
        
        // get job list from firebase
        db.collection("jobInfo").addSnapshotListener { querySnapshot, error in
            if let documents = querySnapshot?.documents {
                self.jobs = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: JobInfo.self)
                }
            }
        }
        
        // get studentJob information list from firebase
        db.collection("studentJobInfo").addSnapshotListener { querySnapshot, error in
            if let documents = querySnapshot?.documents {
                self.studentJobs = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: StudentJobInfo.self)
                }
            }
        }
    }
    
    // user functions
    func addUser(_ user: UserInfo) {
        try? db.collection("userInfo").document().setData(from: user)
    }
    
    func updateUser(_ user: UserInfo) {
        try? db.collection("userInfo").document(user.id!).setData(from: user, merge: true)
    }
    
    // job functions
    func addJob(_ job: JobInfo) {
        try? db.collection("jobInfo").document().setData(from: job)
    }
    
    // studentJob functions
    func addStudentJob(_ studentJob: StudentJobInfo) {
        try? db.collection("studentJobInfo").document().setData(from: studentJob)
    }
    
    func updateStudentJob(_ studentJob: StudentJobInfo) {
        try? db.collection("studentJobInfo").document(studentJob.id!).setData(from: studentJob)
    }
    
    // google sign in-related information and functions
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    
    func signIn() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.configuration = configuration
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {  [unowned self] (userResult, error) in
                authenticateUser(for: userResult?.user, with: error)
            }
        }
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
        guard let idToken = user?.idToken else {
            return
        }
      
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user?.accessToken.tokenString ?? "nil")
      
      Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
        if let error = error {
          print(error.localizedDescription)
        } else {
            var googleUser = GIDSignIn.sharedInstance.currentUser
            let users = db.collection("userInfo")
            users.whereField("email", isEqualTo: "\(googleUser?.profile?.email ?? "")")
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if (querySnapshot!.documents.count == 0) {
                            self.user.email = "nil"
                        } else {
                            for document in querySnapshot!.documents {
                                self.user.docToUser(document: document.data(), documentID: document.documentID)
                            }
                        }
                        self.state = .signedIn
                    }
                }
          
        }
      }
    }
    
    func signOut() {
      GIDSignIn.sharedInstance.signOut()
      
      do {
        try Auth.auth().signOut()
        
        state = .signedOut
      } catch {
        print(error.localizedDescription)
      }
    }
}

struct DataModelInfo_Previews: PreviewProvider {
   static var previews: some View {
       DataModelInfo()
   }
}
