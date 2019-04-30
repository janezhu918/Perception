import UIKit

class SavedVideos: UIView {
  
  lazy var myCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize.init(width: 150, height: 100)
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets.init(top: 3, left: 20, bottom: 3, right: 20)
    let cv = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout)
    cv.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.2039215686, blue: 0.3450980392, alpha: 1)
    return cv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
    commonInit()
    
  }
  
  func commonInit() {
    backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.2039215686, blue: 0.3450980392, alpha: 1)
    addSubview(myCollectionView)
    myCollectionView.register(FavoriteCollectionCell.self, forCellWithReuseIdentifier: "FavoriteCell")
    cvConstrains()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func cvConstrains() {
    myCollectionView.translatesAutoresizingMaskIntoConstraints = false
    [myCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
     myCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
     myCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
     myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)]
      .forEach{$0.isActive = true }
    
  }
  
  
}
