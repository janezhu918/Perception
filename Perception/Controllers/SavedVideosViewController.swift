import UIKit

class SavedVideosViewController: UIViewController {
    
    let favoriteVideos = SavedVideos()
    let savedVideo = 3  //this should be an array of videos

    override func viewDidLoad() {
        super.viewDidLoad()
        print("I've arrived at this page")
        navigationController?.navigationBar.isHidden = false
        view.addSubview(favoriteVideos)
        favoriteVideos.myCollectionView.delegate = self
        favoriteVideos.myCollectionView.dataSource = self 
    }
    
}

extension SavedVideosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedVideo
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = favoriteVideos.myCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCollectionCell else { return UICollectionViewCell() }
        cell.textLabel.text = "Test text"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    

}
