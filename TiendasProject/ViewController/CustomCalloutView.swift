

import UIKit

protocol CustomCalloutViewDelegate: class {
    func didTapInfoButton(data: listModel)
}

class CustomCalloutView: UIView {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    
    weak var delegate: CustomCalloutViewDelegate?
    var spotData: listModel?
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.didTapInfoButton(data: spotData!)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomCalloutView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
