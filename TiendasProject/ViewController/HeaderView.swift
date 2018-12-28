
import UIKit
protocol HeaderViewDelegate: class {
    func toggleSection(header: HeaderView, section: Int)
}

class HeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var arrowDown: UIImageView!
    @IBOutlet weak var titleLabel: UILabel?
    
    @IBOutlet weak var departmentSelection: UILabel!
    @IBOutlet weak var headerDescription: UILabel!
  
    var section: Int = 0
    weak var delegate: HeaderViewDelegate?
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }
    func setCollapsed(collapsed: Bool) {
        arrowDown?.rotate(collapsed ? 0.0 : .pi)
    }
    
    
    
  
    
}

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}
