import UIKit

class EmptyStateView: UIView {
    
    lazy var emptyStateMessage: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = Constants.emptyStateViewMessage
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = Constants.perceptionNavyColor
        addSubview(emptyStateMessage)
        addEmptyStateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addEmptyStateView() {
        emptyStateMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateMessage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            emptyStateMessage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
            ])
    }
    
}
