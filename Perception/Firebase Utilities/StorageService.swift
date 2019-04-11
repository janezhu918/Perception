import Foundation
import FirebaseStorage

enum Result<Value> {
  case success(Value)
  case failure(error:Error)
}

protocol ImageStorageService {
  func storeImage(data:Data, id:String)
  func deleteImage(image:PerceptionImage)
  var imageServiceDelgate: ImageStorageServiceDelegate? { get set }
}

protocol ImageStorageServiceDelegate: AnyObject {
  func storageService(_ storageService: ImageStorageService, didReceiveImageURL imageURL: URL)
  func storageService(_ storageService: ImageStorageService, didDeleteImage success: Bool)
  func storageService(_ storageService: ImageStorageService, didReceiveError error: Error)
}

protocol VideoStorageService {
  func storeVideo(data:Data, id:String)
  func storeVideo(url:URL, id:String)
  func deleteVideo(video:PerceptionVideo)
  var videoServiceDelegate: VideoStorageServiceDelegate? { get set }
}

protocol VideoStorageServiceDelegate: AnyObject {
  func storageService(_ storageService: VideoStorageService, didReceiveVideoURL imageURL: URL)
  func storageService(_ storageService: VideoStorageService, didDeleteVideo success: Bool)
  func storageService(_ storageService: VideoStorageService, didReceiveError error: Error)
}

final class StorageService: ImageStorageService, VideoStorageService {
  private enum Content: String {
    case video
    case image
    
    public var mediaType: String {
      switch self {
      case .video: return "application/mp4"
      case .image: return "image"
      }
    }
  }
  public weak var imageServiceDelgate: ImageStorageServiceDelegate?
  public weak var videoServiceDelegate: VideoStorageServiceDelegate?
  
  private let rootRef: StorageReference = {
    let storage = Storage.storage()
    return storage.reference()
  }()
  
  private lazy var imageFolderReference: StorageReference = {
    return rootRef.child("\(Content.image.rawValue)s")
  }()
  
  private lazy var videoFolderReference: StorageReference = {
    return rootRef.child("\(Content.video.rawValue)s")
  }()
  
  public func deleteImage(image: PerceptionImage) {
    let fileReference = imageFolderReference.child(image.id)
    fileReference.delete { (error) in
      guard error == nil else {
        self.imageServiceDelgate?.storageService(self, didReceiveError: error!)
        return
      }
    }
    imageServiceDelgate?.storageService(self, didDeleteImage: true)
  }
  
  public func storeImage(data: Data, id:String) {
    let fileReference = imageFolderReference.child("\(id).png")
    storeContentData(content: .image, data: data,
                     fileReference: fileReference) { (result) in
                      switch result {
                      case .failure(error: let error):
                        self.imageServiceDelgate?.storageService(self, didReceiveError: error)
                      case .success(let url):
                        self.imageServiceDelgate?.storageService(self, didReceiveImageURL: url)
                      }
    }
  }
  
  public func storeVideo(data: Data, id: String) {
    let fileReference = videoFolderReference.child("\(id).mp4")
    storeContentData(content: .image, data: data,
                     fileReference: fileReference) { (result) in
                      switch result {
                      case .failure(error: let error):
                        self.videoServiceDelegate?.storageService(self, didReceiveError: error)
                      case .success(let url):
                        self.videoServiceDelegate?.storageService(self, didReceiveVideoURL: url)
                      }
    }
  }
  
  public func storeVideo(url: URL, id: String) {
    let fileReference = videoFolderReference.child("\(id).mp4")
    storeContentData(content: .image, url: url,
                     fileReference: fileReference) { (result) in
                      switch result {
                      case .failure(error: let error):
                        self.videoServiceDelegate?.storageService(self, didReceiveError: error)
                      case .success(let url):
                        self.videoServiceDelegate?.storageService(self, didReceiveVideoURL: url)
                      }
    }
  }
  
  public func deleteVideo(video: PerceptionVideo) {
    videoFolderReference.child(video.id).delete { (error) in
      guard error == nil else {
        self.videoServiceDelegate?.storageService(self, didReceiveError: error!)
        return
      }
      self.videoServiceDelegate?.storageService(self, didDeleteVideo: true)
    }
  }
  
  private func storeContentData(content:Content, data:Data,
                                fileReference:StorageReference,
                                completion:@escaping (Result<URL>) -> ()) {
    let metaData = StorageMetadata()
    metaData.contentType = content.mediaType
    
    fileReference.putData(data, metadata: metaData) { (metadata, error) in
      guard let _ = metadata else {
        return
      }
      if let error = error {
        completion(.failure(error: error))
        return
      }
      fileReference.downloadURL { (url, error) in
        if let url = url {
          completion(.success(url))
        } else if let error = error {
          completion(.failure(error: error))
        }
      }
      
    }
  }
  private func storeContentData(content:Content, url:URL,
                                fileReference:StorageReference,
                                completion:@escaping (Result<URL>) -> ()) {
    let metaData = StorageMetadata()
    metaData.contentType = content.mediaType
    
    fileReference.putFile(from: url, metadata: metaData){ (metadata, error) in
      guard let _ = metadata else {
        return
      }
      if let error = error {
        completion(.failure(error: error))
        return
      }
      fileReference.downloadURL { (url, error) in
        if let url = url {
          completion(.success(url))
        } else if let error = error {
          completion(.failure(error: error))
        }
      }
    }
  }
  
}
