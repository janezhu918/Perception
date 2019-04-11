import Foundation

class PerceptionUser {
    let userUID: String
    let displayName: String?
    let firstName: String?
    let lastName: String?
    let photoURL: String?
    
    public var fullName: String {
        return ((firstName ?? "") + " " + (lastName ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(userUID: String, displayName: String?, firstName: String, lastName: String, photoURL: String?) {
        self.userUID = userUID
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.photoURL = photoURL
    }
    
    init(dict: [String:Any]) {
        self.userUID = dict[PerceptionUsersCollectionKeys.userUID] as? String ?? ""
        self.displayName = dict[PerceptionUsersCollectionKeys.displayName] as? String ?? ""
        self.firstName = dict[PerceptionUsersCollectionKeys.firstName] as? String ?? ""
        self.lastName = dict[PerceptionUsersCollectionKeys.lastName] as? String ?? ""
        self.photoURL = dict[PerceptionUsersCollectionKeys.photoURL] as? String ?? ""
    }
}

struct PerceptionUsersCollectionKeys {
    static let userUID = "userUID"
    static let displayName = "displayName"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let photoURL = "photoURL"
}
