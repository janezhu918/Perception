import UIKit

class SavedVideosViewController: UIViewController {
    
    let favoriteVideos = SavedVideos()
    let savedVideo = 1  //this should be an array of videos

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(favoriteVideos)
       
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

}
