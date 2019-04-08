import Foundation
import FirebaseStorage


protocol ImageStorageService {
  func storeImage(data:Data, id:String)
  func deleteImage(image:PerceptionImage)
  var imageServiceDelgate: ImageStorageServiceDelegate? { get set }
}

protocol ImageStorageServiceDelegate: AnyObject {
  func storageService(_ storageService: StorageService, didReceiveImageURL imageURL: URL)
  func storageService(_ storageService: StorageService, didDeleteImage success: Bool)
  func storageService(_ storageService: StorageService, didReceiveError error: Error)
}

final class StorageService: ImageStorageService {
  func deleteImage(image: PerceptionImage) {
    
  }
  
  
  public weak var imageServiceDelgate: ImageStorageServiceDelegate?
  
  private let rootRef: StorageReference = {
    let storage = Storage.storage()
    return storage.reference()
  }()
  
  func storeImage(data: Data, id:String) {
    let imageFolderReference = rootRef.child("images")
    let fileReference = imageFolderReference.child(id)
    let metaData = StorageMetadata()
    metaData.contentType = "image/png"
    fileReference.putData(data, metadata: metaData) { (metadata, error) in
      guard let _ = metadata else {
        return
      }
      if let error = error {
        self.imageServiceDelgate?.storageService(self, didReceiveError: error)
        return
      }
      fileReference.downloadURL { (url, error) in
        if let url = url {
          self.imageServiceDelgate?.storageService(self, didReceiveImageURL: url)
        } else if let error = error {
          self.imageServiceDelgate?.storageService(self, didReceiveError: error)
        }
    }
    
    
    }
    
  }
  
  
}
