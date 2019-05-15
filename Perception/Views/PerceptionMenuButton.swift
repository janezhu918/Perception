
import UIKit
import ExpandingMenu

class PerceptionMenuButton: ExpandingMenuButton {
    private var menuItems = [ExpandingMenuItem]()
    
    public func addButton(title:String,image:UIImage,
                          highlightedImage: UIImage, backgroundImage: UIImage?,
                          backgroundHighlightedImage: UIImage, action:(() -> ())?){
        //    let share = ExpandingMenuItem(size: menuButtonSize, title: "Share", image: UIImage(named: "share")!, highlightedImage: UIImage(named: "share")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
        let menuItem = ExpandingMenuItem(image: image, highlightedImage: highlightedImage, backgroundImage: backgroundImage, backgroundHighlightedImage: backgroundHighlightedImage, itemTapped: action)
        menuItems.append(menuItem)
        addMenuItems(menuItems)
    }
    
    
    
    
    
    //    if let videoToShare =  self.currentSKVideoNode?.name,
    
    //      let videoURL = (self.images.first { $0.name == videoToShare })?.videoURLString {
    //      let activityViewController = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
    //      self.present(activityViewController, animated: true)
    //
    //    }
    //    else {
    //      self.showAlert(title: "No image detected to share", message: "Point to an image to share it")
    //    }
    //  }
}
