import Foundation
struct PerceptionVideo {
  public let createdAt: String
  public let urlString: String
  public let name: String
  public let id: String
  public let description: String
  public var currentPlaybackTime: Double
  
  init(name:String, id: String,
       createdAt:String,
       currentPlaybackTime: Double,
       description:String,
       urlString:String){
    self.id = id
    self.name = name
    self.urlString = urlString
    self.createdAt = createdAt
    self.description = description
    self.currentPlaybackTime = currentPlaybackTime
  }
  
  init(document:[String:Any], id: String){
    self.id = id
    self.createdAt = document[PerceptionVideoCollectionKeys.createdAt] as? String ?? ""
    self.urlString = document[PerceptionVideoCollectionKeys.urlString] as? String ?? ""
    self.name = document[PerceptionVideoCollectionKeys.name] as? String ?? ""
    self.description = document[PerceptionVideoCollectionKeys.description] as? String ?? ""
    self.currentPlaybackTime = document[PerceptionVideoCollectionKeys.currentPlaybackTime] as? Double ?? 0.0
  }
}

extension PerceptionVideo: FirebaseRepresentable {
  var firebaseRepresentation: [String : Any] {
    return [PerceptionVideoCollectionKeys.id: id,
            PerceptionVideoCollectionKeys.name: name,
            PerceptionVideoCollectionKeys.createdAt: createdAt,
            PerceptionVideoCollectionKeys.urlString: urlString,
            PerceptionVideoCollectionKeys.description: description,
            PerceptionVideoCollectionKeys.currentPlaybackTime: currentPlaybackTime]
  }
  
  
}
