import Foundation

class PerceptionUser {
    let userUID: String
    let email: String
    let displayName: String?
    let firstName: String?
    let lastName: String?
    let photoURL: String?
    let gender: String?
    let birthday: String?
    let zipCode: String?
    
    public var fullName: String {
        return ((firstName ?? "") + " " + (lastName ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(userUID: String, email: String, displayName: String?, firstName: String?, lastName: String?, photoURL: String?, gender: String?, birthday: String?, zipCode: String?) {
        self.userUID = userUID
        self.email = email
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.photoURL = photoURL
        self.gender = gender
        self.birthday = birthday
        self.zipCode = zipCode
    }
    
    init(dict: [String:Any]) {
        self.userUID = dict[PerceptionUsersCollectionKeys.userUID] as? String ?? ""
        self.email = dict[PerceptionUsersCollectionKeys.email] as? String ?? ""
        self.displayName = dict[PerceptionUsersCollectionKeys.displayName] as? String ?? ""
        self.firstName = dict[PerceptionUsersCollectionKeys.firstName] as? String ?? ""
        self.lastName = dict[PerceptionUsersCollectionKeys.lastName] as? String ?? ""
        self.photoURL = dict[PerceptionUsersCollectionKeys.photoURL] as? String ?? ""
        self.gender = dict[PerceptionUsersCollectionKeys.gender] as? String ?? ""
        self.birthday = dict[PerceptionUsersCollectionKeys.birthday] as? String ?? ""
        self.zipCode = dict[PerceptionUsersCollectionKeys.zipCode] as? String ?? ""
    }
}

struct PerceptionUsersCollectionKeys {
    static let userUID = "userUID"
    static let email = "email"
    static let displayName = "displayName"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let photoURL = "photoURL"
    static let gender = "gender"
    static let birthday = "birthday"
    static let zipCode = "zipCode"
}
