//
//  VideoView.swift
//  Perception
//
//  Created by Elizabeth Peraza  on 4/8/19.
//  Copyright © 2019 JaneZhu. All rights reserved.
//

import UIKit
import AVFoundation

class VideoView: UIView {

    public var player: AVPlayer? {
        get {
            return playerLayer.player
        } set {
            playerLayer.player = newValue
        }
    }
    
    public var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

}
