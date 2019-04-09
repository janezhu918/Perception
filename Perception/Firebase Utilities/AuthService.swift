import Foundation
import FirebaseAuth
import ProgressHUD

protocol AuthServiceCreateNewAccountDelegate: AnyObject {
    func didReceiveErrorCreatingAccount(_ authservice: AuthService, error: Error)
    func didCreateNewAccount(_ authservice: AuthService, perceptionUser: PerceptionUser)
}

protocol AuthServiceExistingAccountDelegate: AnyObject {
    func didReceiveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error)
    func didSignInToExistingAccount(_ authservice: AuthService, user: User)
}

protocol AuthServiceSignOutDelegate: AnyObject {
    func didSignOutWithError(_ authservice: AuthService, error: Error)
    func didSignOut(_ authservice: AuthService)
}

final class AuthService {
    weak var authserviceCreateNewAccountDelegate: AuthServiceCreateNewAccountDelegate?
    weak var authserviceExistingAccountDelegate: AuthServiceExistingAccountDelegate?
    weak var authserviceSignOutDelegate: AuthServiceSignOutDelegate?
    
    public func createNewAccount(username: String, email: String, password: String) {
        ProgressHUD.show()
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.authserviceCreateNewAccountDelegate?.didReceiveErrorCreatingAccount(self, error: error)
                return
            } else if let authDataResult = authDataResult {
                
                // update displayName for auth user
                let request = authDataResult.user.createProfileChangeRequest()
                request.displayName = username
                request.commitChanges(completion: { (error) in
                    if let error = error {
                        self.authserviceCreateNewAccountDelegate?.didReceiveErrorCreatingAccount(self, error: error)
                        return
                    }
                })
                
//                let blogger = Blogger.init(userId: authDataResult.user.uid,
//                                           displayName: username,
//                                           email: email,
//                                           photoURL: nil,
//                                           coverImageURL: nil,
//                                           joinedDate: Date.getISOTimestamp(),
//                                           firstName: nil,
//                                           lastName: nil,
//                                           bio: nil,
//                                           blockedUsers: [],
//                                           twitter: nil,
//                                           github: nil,
//                                           linkedIn: nil)
//                DBService.createBlogger(blogger: blogger, completion: { (error) in
//                    if let error = error {
//                        self.authserviceCreateNewAccountDelegate?.didReceiveErrorCreatingAccount(self, error: error)
//                    } else {
//                        self.authserviceCreateNewAccountDelegate?.didCreateNewAccount(self, blogger: blogger)
//                        ProgressHUD.dismiss()
//                    }
//                })
            }
        }
    }
    
    public func signInExistingAccount(email: String, password: String) {
        ProgressHUD.show()
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.authserviceExistingAccountDelegate?.didReceiveErrorSigningToExistingAccount(self, error: error)
            } else if let authDataResult = authDataResult {
                self.authserviceExistingAccountDelegate?.didSignInToExistingAccount(self, user: authDataResult.user)
                ProgressHUD.dismiss()
            }
        }
    }
    
    public func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    public func signOutAccount() {
        ProgressHUD.show()
        do {
            try Auth.auth().signOut()
            authserviceSignOutDelegate?.didSignOut(self)
            ProgressHUD.dismiss()
        } catch {
            authserviceSignOutDelegate?.didSignOutWithError(self, error: error)
        }
    }
}
