import Foundation
import FirebaseFirestore

protocol FirebaseRepresentable {
  var firebaseRepresentation: [String: Any] { get }
}

protocol ImageService {
  var imageServiceDelegate: ImageServiceDelegate? { get set }
  func storeImage(image:PerceptionImage)
  func deleteImage(image:PerceptionImage)
  func fetchImage(image:PerceptionImage)
  func updateImage(image:PerceptionImage, newValues:[String:Any])
  func generateImageId() -> String
}

protocol ImageServiceDelegate: AnyObject {
  func imageService(_ imageService: ImageService, didReceiveError error:Error)
  func imageService(_ imageService: ImageService, didDeleteImage success: Bool)
  func imageService(_ imageService: ImageService, didReceiveImage image: PerceptionImage)
  func imageService(_ imageService: ImageService, didReceiveImages images: [PerceptionImage])
}

protocol VideoService {
  var videoServiceDelegate: VideoServiceDelegate? { get set }
  func storeVideo(video:PerceptionVideo)
  func deleteVideo(video:PerceptionVideo)
  func fetchVideo(video:PerceptionVideo)
  func updateVideo(video:PerceptionVideo, newValues:[String:Any])
  func generateVideoId() -> String
}



protocol VideoServiceDelegate: AnyObject {
  func videoService(_ videoService: VideoService, didReceiveError error:Error)
  func videoService(_ videoService: VideoService, didDeleteVideo success: Bool)
  func videoService(_ videoService: VideoService, didReceiveVideo video: PerceptionVideo)
}

extension VideoServiceDelegate {
  func videoService(_ videoService: VideoService, didDeleteVideo success: Bool) { }
  func videoService(_ videoService: VideoService, didReceiveVideo video: PerceptionVideo) { }
}

protocol SavedVideoService {
  var savedVideoServiceDelegate: SavedVideoServiceDelegate? { get set }
  func storeVideo(video:SavedVideo)
  func deleteVideo(video:SavedVideo)
  func fetchVideo(video:SavedVideo)
  func generateSavedVideoId() -> String
}

protocol SavedVideoServiceDelegate: AnyObject {
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveError error:Error)
  func savedVideoService(_ savedVideoService: SavedVideoService, didDeleteVideo success: Bool)
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveVideo video: SavedVideo)
}

extension SavedVideoServiceDelegate {
  func savedVideoService(_ savedVideoService: SavedVideoService, didDeleteVideo success: Bool) { }
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveVideo video: SavedVideo) { }
}

final class DatabaseService {
  fileprivate enum FirebaseCollections: String {
    case videos
    case images
    case users
    case savedVideos
  }
  public weak var imageServiceDelegate: ImageServiceDelegate?
  public weak var videoServiceDelegate: VideoServiceDelegate?
  public weak var savedVideoServiceDelegate: SavedVideoServiceDelegate?
  
    public static var firestoreDB: Firestore = {
        let db = Firestore.firestore()
        return db
    }()
  
  private var fireStore: Firestore = {
    return Firestore.firestore()
  }()
  
  fileprivate lazy var imagesCollection: CollectionReference = {
    return fireStore.collection(FirebaseCollections.images.rawValue)
  }()
  
  fileprivate lazy var videosCollection: CollectionReference = {
    return fireStore.collection(FirebaseCollections.videos.rawValue)
  }()
  
  fileprivate lazy var savedVideosCollection: CollectionReference = {
    return fireStore.collection(FirebaseCollections.savedVideos.rawValue)
  }()
  
  fileprivate lazy var usersCollection: CollectionReference = {
    return fireStore.collection(FirebaseCollections.users.rawValue)
  }()
  
}

extension DatabaseService: ImageService {
  func generateImageId() -> String {
    return imagesCollection.document().documentID
  }
  
  func updateImage(image: PerceptionImage, newValues: [String : Any]) {
    imagesCollection.document(image.id)
      .updateData(newValues) { (error) in
        if let error = error {
          self.imageServiceDelegate?.imageService(self, didReceiveError: error)
        }
    }
  }
  
  
  func storeImage(image: PerceptionImage) {
    imagesCollection.addDocument(data: image.firebaseRepresentation) { (error) in
      if let error = error {
        self.imageServiceDelegate?.imageService(self, didReceiveError: error)
      }
    }
  }
  
  func deleteImage(image: PerceptionImage) {
    imagesCollection.document(image.id)
      .delete { (error) in
        if let error = error {
          self.imageServiceDelegate?.imageService(self, didReceiveError: error)
        }
    }
  }
  
  func fetchImage(image: PerceptionImage) {
    imagesCollection.document(image.id).getDocument { (snapshot, error) in
      if let error = error {
        self.imageServiceDelegate?.imageService(self, didReceiveError: error)
      } else if let snapshot = snapshot, let imageData = snapshot.data() {
        let image = PerceptionImage(document: imageData, id: snapshot.documentID)
        self.imageServiceDelegate?.imageService(self, didReceiveImage: image)
      }
    }
  }
  
  
}

extension DatabaseService: VideoService {
  func generateVideoId() -> String {
    return videosCollection.document().documentID
  }
  
  func updateVideo(video: PerceptionVideo, newValues: [String : Any]) {
    videosCollection.document(video.id)
      .updateData(newValues) { (error) in
        if let error = error {
          self.videoServiceDelegate?.videoService(self, didReceiveError: error)
        }
    }
  }
  
  func storeVideo(video: PerceptionVideo) {
    videosCollection.addDocument(data: video.firebaseRepresentation) { (error) in
      if let error = error {
        self.videoServiceDelegate?.videoService(self, didReceiveError: error)
      }
    }
  }
  
  func deleteVideo(video: PerceptionVideo) {
    videosCollection.document(video.id)
      .delete { (error) in
        if let error = error {
          self.videoServiceDelegate?.videoService(self, didReceiveError: error)
        }
    }
  }
  
  func fetchVideo(video: PerceptionVideo) {
    videosCollection.document(video.id).getDocument { (snapshot, error) in
      if let error = error {
        self.videoServiceDelegate?.videoService(self, didReceiveError: error)
      } else if let snapshot = snapshot, let videoData = snapshot.data() {
        let video = PerceptionVideo(document: videoData, id: snapshot.documentID)
        self.videoServiceDelegate?.videoService(self, didReceiveVideo: video)
      }
    }
  }
}


extension DatabaseService {
    static public func createPerceptionUser(perceptionUser: PerceptionUser, completion: @escaping (Error?) -> Void) {
        firestoreDB
            .collection(FirebaseCollections.users.rawValue)
            .document(perceptionUser.userUID)
            .setData([PerceptionUsersCollectionKeys.userUID : perceptionUser.userUID,
                      PerceptionUsersCollectionKeys.email : perceptionUser.email,
                      PerceptionUsersCollectionKeys.displayName : perceptionUser.displayName ?? "",
                      PerceptionUsersCollectionKeys.firstName : perceptionUser.firstName ?? "",
                      PerceptionUsersCollectionKeys.lastName : perceptionUser.lastName ?? "",
                      PerceptionUsersCollectionKeys.photoURL : perceptionUser.photoURL ?? ""]) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
}

extension DatabaseService: SavedVideoService {
  
  func generateSavedVideoId() -> String {
    return savedVideosCollection.document().documentID
  }
  
  func storeVideo(video: SavedVideo) {
    savedVideosCollection.addDocument(data: video.firebaseRepresentation) { (error) in
      if let error = error {
        self.videoServiceDelegate?.videoService(self, didReceiveError: error)
      }
    }
  }
  
  func deleteVideo(video: SavedVideo) {
    savedVideosCollection.document(video.id)
      .delete { (error) in
        if let error = error {
          self.videoServiceDelegate?.videoService(self, didReceiveError: error)
        }
    }
  }
  
  func fetchVideo(video: SavedVideo) {
    savedVideosCollection.document(video.id).getDocument { (snapshot, error) in
      if let error = error {
        self.videoServiceDelegate?.videoService(self, didReceiveError: error)
      } else if let snapshot = snapshot, let videoData = snapshot.data() {
        let video = PerceptionVideo(document: videoData, id: snapshot.documentID)
        self.videoServiceDelegate?.videoService(self, didReceiveVideo: video)
      }
    }
  }
  
  
  
  
}
