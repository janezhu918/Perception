import Foundation
import FirebaseFirestore

protocol FirebaseRepresentable {
  var firebaseRepresentation: [String: Any] { get }
}

enum FirebaseError: Error {
  case duplicateError(String)
}

protocol ImageService {
  func storeImage(image:PerceptionImage, completion:@escaping(Result<Bool>) -> Void)
  func deleteImage(image:PerceptionImage, completion:@escaping(Result<Bool>) -> Void)
  func fetchImage(image:PerceptionImage,
                  completion:@escaping(Result<PerceptionImage>) -> Void)
  func fetchImage(imageName:String,
                  completion:@escaping(Result<PerceptionImage>) -> Void)
  func fetchImages(contextID:String,
                  completion:@escaping(Result<[PerceptionImage]>) -> Void)
  func updateImage(image:PerceptionImage, newValues:[String:Any],
                   completion:@escaping(Result<Bool>) -> Void)
  func generateImageId() -> String
}

protocol VideoService {
  func storeVideo(video:PerceptionVideo, completion:@escaping(Result<Bool>) -> Void)
  func deleteVideo(video:PerceptionVideo, completion:@escaping(Result<Bool>) -> Void)
  func fetchVideo(name:String,
                  completion:@escaping(Result<PerceptionVideo>) -> Void)
  func fetchVideos(completion: @escaping (Result<[PerceptionVideo]>) -> Void)
  func updateVideo(video:PerceptionVideo, newValues:[String:Any],
                   completion:@escaping(Result<Bool>) -> Void)
  func generateVideoId() -> String
}

protocol SavedVideoService {
  var savedVideoServiceDelegate: SavedVideoServiceDelegate? { get set }
  func storeVideo(video:SavedVideo, user:PerceptionUser,
                  completion: @escaping (Result<Bool>) -> Void)
  func deleteVideo(video:SavedVideo, user:PerceptionUser)
  func fetchVideo(video:SavedVideo, user:PerceptionUser)
  func fetchUserSavedVideos(user:PerceptionUser)
  func generateSavedVideoId(user:PerceptionUser) -> String
}

protocol SavedVideoServiceDelegate: AnyObject {
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveError error:Error)
  func savedVideoService(_ savedVideoService: SavedVideoService, didDeleteVideo success: Bool)
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveVideo video: SavedVideo)
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveVideos videos: [SavedVideo])
}

extension SavedVideoServiceDelegate {
  func savedVideoService(_ savedVideoService: SavedVideoService, didDeleteVideo success: Bool) { }
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveVideo video: SavedVideo) { }
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveVideos videos: [SavedVideo]) { }
}

final class DatabaseService {
  fileprivate enum FirebaseCollections: String {
    case videos
    case images
    case users
    case savedVideos
  }
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
  
  fileprivate func savedVideosCollection(user:PerceptionUser) -> CollectionReference {
    let userDocument = usersCollection.document(user.userUID)
    return userDocument.collection(FirebaseCollections.savedVideos.rawValue)
  }
  
  fileprivate lazy var usersCollection: CollectionReference = {
    return fireStore.collection(FirebaseCollections.users.rawValue)
  }()
  
}

extension DatabaseService: ImageService {
  
  func storeImage(image: PerceptionImage, completion: @escaping (Result<Bool>) -> Void) {
    imagesCollection.addDocument(data: image.firebaseRepresentation) { (error) in
      if let error = error {
        completion(.failure(error: error))
      }
      completion(.success(true))
    }
  }
  
  func deleteImage(image: PerceptionImage, completion: @escaping (Result<Bool>) -> Void) {
    imagesCollection.document(image.id)
      .delete { (error) in
        if let error = error {
          completion(.failure(error: error))
        }
        completion(.success(true))
    }
  }
  
  func fetchImage(image: PerceptionImage, completion: @escaping (Result<PerceptionImage>) -> Void) {
    imagesCollection.document(image.id).getDocument { (snapshot, error) in
      if let error = error {
        completion(.failure(error: error))
      } else if let snapshot = snapshot, let imageData = snapshot.data() {
        let image = PerceptionImage(document: imageData, id: snapshot.documentID)
        completion(.success(image))
      }
    }
  }
  
  func fetchImage(imageName: String, completion: @escaping (Result<PerceptionImage>) -> Void) {
    imagesCollection.whereField(PerceptionImageCollectionKeys.name, isEqualTo: imageName)
      .getDocuments { (snapshot, error) in
        if let error = error {
          completion(.failure(error: error))
        } else if let document = snapshot?.documents.first {
          let image = PerceptionImage(document: document.data(), id: document.documentID)
          completion(.success(image))
        }
    }
  }
  
  func fetchImages(contextID: String, completion: @escaping (Result<[PerceptionImage]>) -> Void) {
    imagesCollection.whereField(PerceptionImageCollectionKeys.contextID, isEqualTo: contextID)
      .getDocuments { (snapshot, error) in
        if let error = error {
          completion(.failure(error: error))
        } else if let snapshot = snapshot {
          let images = snapshot.documents.map { PerceptionImage(document: $0.data(),
                                                                id: $0.documentID) }
          completion(.success(images))
        }
    }
  }
  
  func updateImage(image: PerceptionImage, newValues: [String : Any],
                   completion: @escaping (Result<Bool>) -> Void) {
    imagesCollection.document(image.id)
      .updateData(newValues) { (error) in
        if let error = error {
          completion(.failure(error: error))
        }
        completion(.success(true))
    }
  }
  
  func generateImageId() -> String {
    return imagesCollection.document().documentID
  }
}

extension DatabaseService: VideoService {
  func storeVideo(video: PerceptionVideo, completion: @escaping (Result<Bool>) -> Void) {
    videosCollection.addDocument(data: video.firebaseRepresentation) { (error) in
      if let error = error {
        completion(.failure(error: error))
      }
      completion(.success(true))
    }
  }
  
  func deleteVideo(video: PerceptionVideo, completion: @escaping (Result<Bool>) -> Void) {
    videosCollection.document(video.id)
      .delete { (error) in
        if let error = error {
          completion(.failure(error: error))
        }
        completion(.success(true))
    }
  }
  
  func fetchVideo(name:String, completion: @escaping (Result<PerceptionVideo>) -> Void) {
    videosCollection.whereField(PerceptionVideoCollectionKeys.name, isEqualTo: name).getDocuments { (snapshot, error) in
      if let error = error {
        completion(.failure(error: error))
      } else if let document = snapshot?.documents.first {
        let video = PerceptionVideo(document: document.data(), id: document.documentID)
        completion(.success(video))
      }
    }
  }
  
  func fetchVideos(completion: @escaping (Result<[PerceptionVideo]>) -> Void) {
    videosCollection.getDocuments { (snapshot, error) in
      if let error = error {
        completion(.failure(error: error))
      } else if let documents = snapshot?.documents {
        let videos = documents.map { (document) in
          PerceptionVideo(document: document.data(), id: document.documentID)
        }
        completion(.success(videos))
      }
    }
  }
  
  func updateVideo(video: PerceptionVideo, newValues: [String : Any], completion: @escaping (Result<Bool>) -> Void) {
    videosCollection.document(video.id)
      .updateData(newValues) { (error) in
        if let error = error {
          completion(.failure(error: error))
        }
        completion(.success(true))
    }
  }
  
  func generateVideoId() -> String {
    return videosCollection.document().documentID
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
    
    static public func updatePerceptionUser(perceptionUser: PerceptionUser, completion: @escaping (Error?) -> Void) {
        firestoreDB
        .collection(FirebaseCollections.users.rawValue)
        .document(perceptionUser.userUID)
            .updateData([PerceptionUsersCollectionKeys.displayName : perceptionUser.displayName ?? "",
                         PerceptionUsersCollectionKeys.firstName : perceptionUser.firstName ?? "",
                         PerceptionUsersCollectionKeys.lastName : perceptionUser.lastName ?? "",
                         PerceptionUsersCollectionKeys.gender : perceptionUser.gender ?? "",
                         PerceptionUsersCollectionKeys.birthday : perceptionUser.birthday ?? "",
                         PerceptionUsersCollectionKeys.zipCode : perceptionUser.zipCode ?? ""]) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
    
    static public func fetchPerceptionUser(uid: String, completion: @escaping (PerceptionUser?, Error?) -> Void) {
        firestoreDB
            .collection(FirebaseCollections.users.rawValue)
            .whereField("userUID", isEqualTo: uid)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else if let snapshot = snapshot?.documents.first {
                    let perceptionUser = PerceptionUser(dict: snapshot.data())
                    completion(perceptionUser, nil)
                }
        }
    }
}

extension DatabaseService: SavedVideoService {
    
    func generateSavedVideoId(user:PerceptionUser) -> String {
        return savedVideosCollection(user: user).document().documentID
    }
    
    func storeVideo(video: SavedVideo, user:PerceptionUser,
                    completion: @escaping (Result<Bool>) -> Void) {
      savedVideosCollection(user: user)
        .whereField(SavedVideoCollectionKeys.name, isEqualTo: video.name)
        .whereField(SavedVideoCollectionKeys.urlString, isEqualTo: video.urlString)
        .getDocuments { (snapshot, error) in
          if let error = error {
            completion(.failure(error: error))
          } else if let snapshot = snapshot {
            guard snapshot.documents.count == 0 else {
              let duplicateError = FirebaseError.duplicateError("Video with name \(video.name) exists")
              completion(.failure(error: duplicateError))
              return
            }
            self.savedVideosCollection(user: user).addDocument(data: video.firebaseRepresentation) { (error) in
              if let error = error {
                completion(.failure(error: error))
              }
              completion(.success(true))
            }
          }
      }
      
      
  }
    
    func deleteVideo(video: SavedVideo, user:PerceptionUser) {
        savedVideosCollection(user: user).document(video.id)
            .delete { (error) in
                if let error = error {
                    self.savedVideoServiceDelegate?.savedVideoService(self, didReceiveError: error)
                }
        }
    }
    
    func fetchVideo(video: SavedVideo, user:PerceptionUser) {
        savedVideosCollection(user: user).document(video.id).getDocument { (snapshot, error) in
            if let error = error {
                self.savedVideoServiceDelegate?.savedVideoService(self, didReceiveError: error)
            } else if let snapshot = snapshot, let videoData = snapshot.data() {
                let video = SavedVideo(document: videoData, id: snapshot.documentID)
                self.savedVideoServiceDelegate?.savedVideoService(self, didReceiveVideo: video)
            }
        }
    }
    
    func fetchUserSavedVideos(user:PerceptionUser) {
        savedVideosCollection(user: user).addSnapshotListener { (snapshot, error) in
            if let error = error {
                self.savedVideoServiceDelegate?.savedVideoService(self, didReceiveError: error)
            } else if let snapshot = snapshot {
                let videos = snapshot.documents.compactMap { (document) in
                    SavedVideo(document: document.data(), id: document.documentID)
                }
                self.savedVideoServiceDelegate?.savedVideoService(self, didReceiveVideos: videos)
            }
        }
    }
    
}
