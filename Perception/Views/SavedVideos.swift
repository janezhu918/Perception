import UIKit

class SavedVideos: UIView {
    
    lazy var videoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 200, height: Constants.savedVideoCollectionViewCellNonExpandedHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        cv.backgroundColor = Constants.perceptionNavyColor
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    
    func commonInit() {
        backgroundColor = Constants.perceptionNavyColor
        addSubview(videoCollectionView)
        videoCollectionView.register(FavoriteCollectionCell.self, forCellWithReuseIdentifier: "FavoriteCell")
        cvConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cvConstrains() {
        videoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        [videoCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor), videoCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor), videoCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor), videoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)]
            .forEach{$0.isActive = true }
        
    }
}
