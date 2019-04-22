import Foundation
import FirebaseStorage

enum Result<Value> {
  case success(Value)
  case failure(error:Error)
}

protocol ImageStorageService {
  func storeImage(data:Data, id:String, completion:@escaping(Result<URL>) -> Void)
  func deleteImage(image:PerceptionImage, completion:@escaping(Result<Bool>) -> Void)
}

protocol VideoStorageService {
  func storeVideo(data:Data, id:String, completion:@escaping(Result<URL>) -> Void)
  func storeVideo(url:URL, id:String, completion:@escaping(Result<URL>) -> Void)
  func deleteVideo(video:PerceptionVideo, completion:@escaping(Result<Bool>) -> Void)
}

final class StorageService {
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

extension StorageService: ImageStorageService {
  
  public func deleteImage(image: PerceptionImage, completion:@escaping(Result<Bool>) -> Void) {
    let fileReference = imageFolderReference.child(image.id)
    fileReference.delete { (error) in
      guard error == nil else {
        completion(.failure(error: error!))
        return
      }
    }
    completion(.success(true))
  }
  
  public func storeImage(data: Data, id:String, completion:@escaping(Result<URL>) -> Void) {
    let fileReference = imageFolderReference.child("\(id).png")
    storeContentData(content: .image, data: data,
                     fileReference: fileReference) { (result) in
                      switch result {
                      case .failure(error: let error):
                        completion(.failure(error: error))
                      case .success(let url):
                        completion(.success(url))
                      }
    }
  }
}

extension StorageService: VideoStorageService {
  public func storeVideo(data: Data, id: String, completion:@escaping(Result<URL>) -> Void) {
    let fileReference = videoFolderReference.child("\(id).mp4")
    storeContentData(content: .video, data: data,
                     fileReference: fileReference) { (result) in
                      switch result {
                      case .failure(error: let error):
                        completion(.failure(error: error))
                      case .success(let url):
                        completion(.success(url))
                      }
    }
  }
  
  public func storeVideo(url: URL, id: String,  completion:@escaping(Result<URL>) -> Void) {
    let fileReference = videoFolderReference.child("\(id).mp4")
    storeContentData(content: .video, url: url,
                     fileReference: fileReference) { (result) in
                      switch result {
                      case .failure(error: let error):
                        completion(.failure(error: error))
                      case .success(let url):
                        completion(.success(url))
                      }
    }
  }
  
  public func deleteVideo(video: PerceptionVideo, completion:@escaping(Result<Bool>) -> Void) {
    videoFolderReference.child(video.id).delete { (error) in
      guard error == nil else {
        completion(.failure(error: error!))
        return
      }
      completion(.success(true))
    }
  }
}
