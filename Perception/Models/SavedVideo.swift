import Foundation
struct SavedVideo {
  public let savedAt: String
  public let urlString: String
  public let title: String
  public let name: String
  public let id: String
  public let description: String
  
  init(id:String, name:String,
       description: String,
       urlString:String, title:String,
       savedAt:String){
    self.id = id
    self.name = name
    self.urlString = urlString
    self.savedAt = savedAt
    self.description = description
    self.title = title
  }
  
  init(document:[String:Any], id:String){
    self.id = id
    self.name = document[SavedVideoCollectionKeys.name] as? String ?? ""
    self.urlString = document[SavedVideoCollectionKeys.urlString] as? String ?? ""
    self.savedAt = document[SavedVideoCollectionKeys.savedAt] as? String ?? ""
    self.description = document[SavedVideoCollectionKeys.description] as? String ?? ""
    self.title = document[SavedVideoCollectionKeys.title] as? String ?? ""
  }
}

extension SavedVideo: FirebaseRepresentable {
  var firebaseRepresentation: [String : Any] {
    return [SavedVideoCollectionKeys.id: id,
            SavedVideoCollectionKeys.name: name,
            SavedVideoCollectionKeys.urlString: urlString,
            SavedVideoCollectionKeys.savedAt: savedAt,
            SavedVideoCollectionKeys.title: title,
            SavedVideoCollectionKeys.description: description
    ]
  }
  
  
}
