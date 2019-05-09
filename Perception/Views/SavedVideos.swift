import UIKit

class SavedVideos: UIView {

    lazy var myCollectionView: UICollectionView = {
        //CREATE THE LAYOUT:
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 200, height: Constants.savedVideoCollectionViewCellNonExpandedHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        cv.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
       commonInit()
        
    }
    
    func commonInit() {
        backgroundColor = Constants.perceptionNavyColor
        addSubview(myCollectionView)
        myCollectionView.register(FavoriteCollectionCell.self, forCellWithReuseIdentifier: "FavoriteCell")
        cvConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cvConstrains() {
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        [myCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor), myCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor), myCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor), myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)]
          .forEach{$0.isActive = true }
        
    }
    

}
