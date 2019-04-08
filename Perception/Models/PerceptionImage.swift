import Foundation

struct PerceptionImage {
  public enum Orientation: String {
    case up
    case down
    case left
    case right
    case upMirrored
    case downMirrored
    case leftMirrored
    case rightMirrored
  }
  public let videoURLString: String
  public let name: String
  public let urlString: String
  public let orientation: Orientation
  
  init(videoURLString: String,
       name: String,
       urlString: String,
       orientation: Orientation){
    self.videoURLString = videoURLString
    self.name = name
    self.urlString = urlString
    self.orientation = orientation
  }
  
  init(document:[String:Any]){
    self.name = document[PerceptionImageCollectionKeys.name] as? String ?? ""
    self.urlString = document[PerceptionImageCollectionKeys.urlString] as? String ?? ""
    self.videoURLString = document[PerceptionImageCollectionKeys.videoURLString] as? String ?? ""
    let orientationString = document[PerceptionImageCollectionKeys.orientation] as? String ?? ""
    self.orientation = Orientation(rawValue: orientationString)!
  }
  
}
