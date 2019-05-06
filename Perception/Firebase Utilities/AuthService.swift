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
    
    public func createNewAccount(email: String, password: String) {
        ProgressHUD.show()
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.authserviceCreateNewAccountDelegate?.didReceiveErrorCreatingAccount(self, error: error)
                return
            } else if let authDataResult = authDataResult {
                let perceptionUser = PerceptionUser.init(userUID: authDataResult.user.uid,
                                                         email: email,
                                                         displayName: nil,
                                                         firstName: nil,
                                                         lastName: nil,
                                                         photoURL: nil,
                                                         gender: nil,
                                                         birthday: nil,
                                                         zipCode: nil)
                DatabaseService.createPerceptionUser(perceptionUser: perceptionUser, completion: { (error) in
                    if let error = error {
                        self.authserviceCreateNewAccountDelegate?.didReceiveErrorCreatingAccount(self, error: error)
                    } else {
                        self.authserviceCreateNewAccountDelegate?.didCreateNewAccount(self, perceptionUser: perceptionUser)
                    }
                })
            }
        }
    }
    
    public func signInExistingAccount(email: String, password: String) {
        ProgressHUD.show()
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
              self.authserviceExistingAccountDelegate?
                .didReceiveErrorSigningToExistingAccount(self, error: error)
            } else if let authDataResult = authDataResult {
                self.authserviceExistingAccountDelegate?
                  .didSignInToExistingAccount(self, user: authDataResult.user)
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
        } catch {
            authserviceSignOutDelegate?.didSignOutWithError(self, error: error)
        }
    }
}
