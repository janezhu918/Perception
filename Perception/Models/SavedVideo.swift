import Foundation
struct SavedVideo {
  public let savedAt: String
  public let urlString: String
  public let name: String
  public let id: String
  public let description: String
  
  init(id:String, name:String,
       description: String,
       urlString:String,
       savedAt:String){
    self.id = id
    self.name = name
    self.urlString = urlString
    self.savedAt = savedAt
    self.description = description
  }
  
  init(document:[String:Any]){
    self.id = document[SavedVideoCollectionKeys.id] as? String ?? ""
    self.name = document[SavedVideoCollectionKeys.name] as? String ?? ""
    self.urlString = document[SavedVideoCollectionKeys.urlString] as? String ?? ""
    self.savedAt = document[SavedVideoCollectionKeys.savedAt] as? String ?? ""
    self.description = document[SavedVideoCollectionKeys.description] as? String ?? ""
  }
}
