
import UIKit

class TiendasVc: UIViewController {

    @IBOutlet weak var tiendsTableView: UITableView!
    
    var arrayForBool = NSMutableArray()
    var selectedSection = Int()
    var ResultArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ResultArray = [
            ["title": "Departamento", "rows": [["title": "Selecciona el Departamento", "description":["Antioquia","Caldas","quindi","boiaro"]]]],
                
        ["title": "Municipio", "rows": [["title": "Selecciona el Municipio", "description":["Antioquia","Caldas","quindi","boiaro"]]]],
                
    ["title": "Barrio", "rows": [["title": "Selecciona el Barrio", "description":["Antioquia","Caldas","quindi","boiaro"]]]]]
                
        
        for _ in 0...ResultArray.count
        {
            self.arrayForBool.add(false)
        }
        tiendsTableView?.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        tiendsTableView.tableFooterView = UIView()
        tiendsTableView.estimatedRowHeight = 120
        tiendsTableView.rowHeight = UITableViewAutomaticDimension
    }
}


//MARK:- TableView Datasource and AppDelegate
extension TiendasVc : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return ResultArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (arrayForBool[section] as! Bool == true as Bool)
        {
            return 1
        }
        else
        {
            return 0;
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedIndex = indexPath.row
        //detailTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 96;
    }
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        selectedSection = (gestureRecognizer.view?.tag)! as Int
        print (selectedSection)
        selectedSection = selectedSection - 100
        var indexPath = IndexPath(row: 0, section: selectedSection) as NSIndexPath
        if indexPath.row == 0 {
            var collapsed: Bool = arrayForBool[indexPath.section] as! Bool
            for i in 0..<ResultArray.count {
                if indexPath.section == i {
                    arrayForBool[i] = (!collapsed)
                }
            }
            self.tiendsTableView.reloadSections([selectedSection], with: .automatic)
            var collapse: Bool = arrayForBool[indexPath.section] as! Bool
            if (collapse == true)
            {
                var indexPath = IndexPath(row: 0, section: selectedSection)
                self.tiendsTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TiendasTableViewCell
        cell.tiendasCollectionViewCell.dataSource = self
        cell.tiendasCollectionViewCell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView {
            let questionDict = ResultArray.object(at: section) as? NSDictionary
//            headerView.titleLabel?.text = questionDict?.value(forKey:"question") as? String
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            headerView.tag = section+100;
            headerView.addGestureRecognizer(tap)
            return headerView
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        let currentCell = tableView.cellForRow(at: indexPath) as! TiendasTableViewCell
//
//        currentCell.collecViewHeight.constant = currentCell.tiendasCollectionViewCell.contentSize.height;

        
//        CGFloat height = myCollectionView.collectionViewLayout.collectionViewContentSize.height
//        heightConstraint.constant = height
//        self.view.setNeedsLayout() Or self.view.layoutIfNeeded()
        return UITableViewAutomaticDimension
    }
}

extension TiendasVc : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
                return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
  
    
    // make a cell for each cell index path
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
//        return cell
//    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}
