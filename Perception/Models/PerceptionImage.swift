import Foundation

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

struct PerceptionImage {
    public let videoURLString: String
    public let name: String
    public let urlString: String
    public let width: Double
    public let orientation: Orientation
    public let id: String
    public let contextID: String = "local"
    
    init(videoURLString: String,
         name: String, id: String,
         urlString: String, width: Double,
         orientation: Orientation){
        self.videoURLString = videoURLString
        self.name = name
        self.urlString = urlString
        self.orientation = orientation
        self.id = id
        self.width = width
    }
    
    init(document:[String:Any], id:String){
        self.id = id
        self.name = document[PerceptionImageCollectionKeys.name] as? String ?? ""
        self.urlString = document[PerceptionImageCollectionKeys.urlString] as? String ?? ""
        self.videoURLString = document[PerceptionImageCollectionKeys.videoURLString] as? String ?? ""
        let orientationString = document[PerceptionImageCollectionKeys.orientation] as? String ?? ""
        self.orientation = Orientation(rawValue: orientationString)!
        self.width = document[PerceptionImageCollectionKeys.width] as? Double ?? 0.0
    }
    
}

extension PerceptionImage: FirebaseRepresentable {
    var firebaseRepresentation: [String : Any] {
        return [PerceptionImageCollectionKeys.id: id,
                PerceptionImageCollectionKeys.name: name,
                PerceptionImageCollectionKeys.urlString: urlString,
                PerceptionImageCollectionKeys.videoURLString: videoURLString,
                PerceptionImageCollectionKeys.orientation: orientation.rawValue,
                PerceptionImageCollectionKeys.contextID: contextID,
                PerceptionImageCollectionKeys.width: width]
    }
    
    
}
