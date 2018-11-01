
import UIKit

class TiendasTableViewCell: UITableViewCell {
//TIENDAS OUTLETS
    
    @IBOutlet weak var tiendasAddress: UILabel!
    
    @IBOutlet weak var tiendasTitle: UILabel!
    
    @IBOutlet weak var tiendasButton: UIButton!
    
    @IBOutlet weak var tiendasDownArrow: UIImageView!
    
    @IBOutlet weak var tiendasCollectionViewCell: UICollectionView!

    @IBOutlet weak var collecViewHeight: NSLayoutConstraint!
        @IBOutlet weak var isnewImg: UIImageView!
    
    //MARK:- Store List IBOutlet...
    
    @IBOutlet weak var listTitle: UILabel!
    @IBOutlet weak var listAddress: UILabel!
    @IBOutlet weak var listDistance: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
