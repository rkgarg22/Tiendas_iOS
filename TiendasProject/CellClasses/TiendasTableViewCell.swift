
import UIKit

class TiendasTableViewCell: UITableViewCell {

    @IBOutlet weak var tiendasCollectionViewCell: UICollectionView!

    @IBOutlet weak var collecViewHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
