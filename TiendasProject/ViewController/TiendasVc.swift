
import UIKit

class TiendasVc: UIViewController {

    @IBOutlet weak var tiendsTableView: UITableView!
    @IBOutlet weak var buscarButton: UIButtonCustomClass!
    var selectedIndex = Int()
    var ResultArray = NSMutableArray()
    var isdepindex = Int()
    var ismuniindex = Int()
    var burrio = Int()
    var department  = String()
    var municipio = String()
    var burrioString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = -1
        isdepindex = -1;
        ismuniindex = -1;
        burrio = -1;

        
        self.checkvalid()
     
        ResultArray = [
            ["title": "Departamento", "rows": ["title": "Selecciona el Departamento", "description":["Antioquia","Caldas","Quindio","Boyacá","Risaralda","Tolima","Cundinamarca","Valle","Cauca"]]],
                
        ["title": "Municipio", "rows": ["title": "Selecciona el Municipio", "description":
    ["Medellin","Alejandría","Andes","Abejorral","Amaga","Angelopolis","Abriaqui","Amalfi","Angostura"]]],
     
    ["title": "Barrio", "rows": ["title": "Selecciona el Barrio", "description": ["Alfonso Lopez","Aranjuez","Barrio Cristobal","Altos de San Juan","AV Nutibara","Belencito","Americá","AV Las Palmas ","Bomboná"]]]]
        
        
        tiendsTableView.tableFooterView = UIView()
        tiendsTableView.estimatedRowHeight = 120
        tiendsTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func buscarAction(_ sender: Any)
    {
        Alomafire.sharedInstance.department = self.department
        Alomafire.sharedInstance.municipio = self.municipio
        Alomafire.sharedInstance.burrioString = self.burrioString
        
        let Obj =  self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(Obj, animated: true)
    
    }
    func checkvalid()
        {
            let departmentTrimmed = self.department.trimmingCharacters(in: .whitespaces)
             let municipioTrimmed = self.municipio.trimmingCharacters(in: .whitespaces)
               let burrioStringTrimmed = self.burrioString.trimmingCharacters(in: .whitespaces)
            
    if (departmentTrimmed.characters.count > 0 || municipioTrimmed.characters.count > 0 || burrioStringTrimmed.characters.count > 0 )
    {
    self.buscarButton.isUserInteractionEnabled = true
        self.buscarButton.backgroundColor = unselectColor;
   self.buscarButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.buscarButton.setImage(#imageLiteral(resourceName: "magnifier"), for: UIControlState.normal)
    }
    else
    {
        self.buscarButton.isUserInteractionEnabled = false
        self.buscarButton.backgroundColor = selectColor;
        self.buscarButton.setTitleColor(selectTextColor, for: UIControlState.normal)
        self.buscarButton.setImage(#imageLiteral(resourceName: "magnifierGrey"), for: UIControlState.normal)
    }
    }
}


//MARK:- TableView Datasource and AppDelegate
extension TiendasVc : UITableViewDelegate,UITableViewDataSource
{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResultArray.count;
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (selectedIndex == indexPath.row)
        {
           return UITableViewAutomaticDimension
        }
        else
        {
            return 82;
        }
         tiendsTableView.layoutIfNeeded()
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TiendasTableViewCell
        let dict = ResultArray.object(at: indexPath.row) as? NSDictionary
           cell.tiendasTitle.text = dict?.value(forKey:"title") as? String
                    let descriptionDict = dict?.value(forKey:"rows") as?  NSDictionary
        cell.tiendasAddress.text = descriptionDict?.value(forKey:"title") as? String
        cell.tiendasButton.tag = indexPath.row
        cell.tiendasButton.addTarget(self, action: #selector(TiendasVc.handle(_:)), for:.touchUpInside)
        cell.tiendasCollectionViewCell.tag = indexPath.row
        cell.tiendasCollectionViewCell.dataSource = self
        cell.tiendasCollectionViewCell.delegate = self
        if (selectedIndex == indexPath.row)
        {
            cell.tiendasDownArrow.image = #imageLiteral(resourceName: "down-arrow")
            DispatchQueue.main.async {
    cell.tiendasCollectionViewCell .reloadData()
        }
        }
        else
        {
            cell.tiendasDownArrow.image = #imageLiteral(resourceName: "rightarrow")
        }
       
        return cell
    }
    @objc func handle(_ sender : UIButton)
    {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if (selectedIndex == sender.tag)
        {
            selectedIndex = -1
            tiendsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        else
        {
            let index = IndexPath(row: sender.tag, section: 0)
            selectedIndex = sender.tag
            tiendsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
      tiendsTableView.layoutIfNeeded()
    }
}
extension TiendasVc : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! TiendasCollectionViewCell
        
        let dict = ResultArray.object(at: collectionView.tag) as? NSDictionary
        let descriptionDict = dict?.value(forKey:"rows") as?  NSDictionary
        let array = descriptionDict?.value(forKey:"description") as? NSArray
        cell.collectionTag.text = array?.object(at: indexPath.row) as? String ?? "Data"
        if (collectionView.tag == 0)
        {
        if (isdepindex == indexPath.row)
        {
            department = array?.object(at: indexPath.row) as? String ?? "Data"
            cell.cellbackView.backgroundColor = selectColor
        }
        else
        {
            cell.cellbackView.backgroundColor = UIColor.clear
        }
        }
        if (collectionView.tag == 1)
        {
        if (ismuniindex == indexPath.row)
        {
            municipio = array?.object(at: indexPath.row) as? String ?? "Data"
            cell.cellbackView.backgroundColor = selectColor
        }
        else
        {
            cell.cellbackView.backgroundColor = UIColor.clear
        }
        }
        if (collectionView.tag == 2)
        {
        if (burrio == indexPath.row)
        {
            burrioString = array?.object(at: indexPath.row) as? String ?? "Data"
          cell.cellbackView.backgroundColor = selectColor
        }
        else
        {
        cell.cellbackView.backgroundColor = UIColor.clear
        }
        }
        
      return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        let dict = ResultArray.object(at: collectionView.tag) as? NSDictionary
        let descriptionDict = dict?.value(forKey:"rows") as?  NSDictionary
        let array = descriptionDict?.value(forKey:"description") as? NSArray
        return (array?.count)!
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let dict = ResultArray.object(at: collectionView.tag) as? NSDictionary
        let descriptionDict = dict?.value(forKey:"rows") as?  NSDictionary
        let array = descriptionDict?.value(forKey:"description") as? NSArray
        if (collectionView.tag == 0)
        {
            self.department = array?.object(at: indexPath.row) as? String ?? "Data"
            isdepindex = indexPath.row
        
        }
        if (collectionView.tag == 1 && self.municipio.count>0)
        {
             self.municipio = array?.object(at: indexPath.row) as? String ?? "Data"
            ismuniindex = indexPath.row
        }
        if (collectionView.tag == 2 && self.municipio.count>0 && self.burrioString.count > 0)
        {
             self.burrioString = array?.object(at: indexPath.row) as? String ?? "Data"
            burrio = indexPath.row
          
        }
        self .checkvalid()
        collectionView.reloadData()
        print("You selected cell #\(indexPath.item)!")
    }
}
