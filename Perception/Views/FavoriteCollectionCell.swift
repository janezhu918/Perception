//
//  FavoriteCollectionCell.swift
//  Perception
//
//  Created by Elizabeth Peraza  on 4/8/19.
//  Copyright © 2019 JaneZhu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class FavoriteCollectionCell: UICollectionViewCell {
    
   
    lazy var videoView: UIView = {
        let savedVideo = UIView()
        return savedVideo
    }()
  
    
    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Your videos"
        textLabel.textAlignment = .center
        return textLabel
    }()
    
   
    
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
       addSubview(videoView)
        addSubview(textLabel)
        cellConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellConstrains() {
            videoView.translatesAutoresizingMaskIntoConstraints = false
            videoView.topAnchor.constraint(equalTo: topAnchor, constant: 11).isActive = true
            videoView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
            videoView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
            videoView.centerXAnchor.constraint(equalTo:safeAreaLayoutGuide.centerXAnchor).isActive = true

            textLabel.translatesAutoresizingMaskIntoConstraints = false
            [textLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 8),
             textLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: 10),  textLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11), textLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -11)].forEach{ $0.isActive = true }
    }
    
}
