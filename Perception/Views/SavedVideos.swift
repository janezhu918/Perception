import UIKit

class SavedVideos: UIView {

    lazy var myCollectionView: UICollectionView = {
        //CREATE THE LAYOUT:
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 200, height: 275)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 10)
        let cv = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        cv.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
       commonInit()
        
    }
    
    func commonInit() {
        backgroundColor = #colorLiteral(red: 0.1276455522, green: 0.2034990788, blue: 0.3436715901, alpha: 1)
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
