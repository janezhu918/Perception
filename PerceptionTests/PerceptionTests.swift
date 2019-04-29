//
//  PerceptionTests.swift
//  PerceptionTests
//
//  Created by iosdevrookie on 4/15/19.
//  Copyright © 2019 JaneZhu. All rights reserved.
//

import XCTest
@testable import Perception
import Firebase
class PerceptionTests: XCTestCase {
  var storageService = StorageService()
  var databaseService = DatabaseService()
  var auth: Auth!
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    FirebaseApp.configure()
    auth = Auth.auth()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() {
        let exp = expectation(description: "Video stored")
        let exp1 = expectation(description: "Image stored")
        let exp2 = expectation(description: "Video added to firebase")
        let exp3 = expectation(description: "Video and Image added to firebase")
    let imageService: ImageService = databaseService
    let videoService: VideoService = databaseService
    
    let imageId = imageService.generateImageId()
    let videoId = videoService.generateVideoId()
    // ADD WIDTH AND NAME
    let name = "facebook"
    let width = 10.0
    let imageStorageService: ImageStorageService = storageService
    let videoStorageService: VideoStorageService = storageService
    guard let data = UIImage(named: name)?.jpegData(compressionQuality: 1.0),
      let videoURL = Bundle.main.url(forResource: name, withExtension: ".mp4") else {
        return
    }
    imageStorageService.storeImage(data: data, id: imageId) { (result) in
      switch result {
      case .success(let imageURL):
        videoStorageService.storeVideo(url: videoURL, id: videoId, completion: { (result) in
          switch result {
          case .success(let storedVideoURL):
            let date = Date.getISOTimestamp()
            let pvideo = PerceptionVideo(name: name, id: videoId, createdAt: date, currentPlaybackTime: 0, description: "", urlString: storedVideoURL.absoluteString)
            videoService.storeVideo(video: pvideo, completion: { (result) in
              switch result {
              case .success:
                exp.fulfill()
              case .failure(error: let _):
                XCTFail()
              }
            })
            let pImage = PerceptionImage(videoURLString: videoURL.absoluteString, name: name, id: imageId, urlString: imageURL.absoluteString, width: width, orientation: .up)
            imageService.storeImage(image: pImage, completion: { (result) in
              switch result {
              case .success(let success):
                exp1.fulfill()
                XCTAssert(success, "All things are fine")
              case .failure(error: let _):
                XCTFail()
              }
            })
          case .failure(error: let _):
            XCTFail()
          }
        })
      case .failure(error: let _):
        XCTFail()
      }
    }
    wait(for: [exp,exp1,exp2,exp3], timeout: 15.0)
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testDemo() {
    let num = 10
    
    XCTAssertGreaterThan(4, num, "should be greater")
  }
  
  
}
