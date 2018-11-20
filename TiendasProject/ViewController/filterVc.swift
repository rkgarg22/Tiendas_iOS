
import UIKit

class filterVc: UIViewController {
    
    
    @IBOutlet weak var departmentHeightconstraint: NSLayoutConstraint!
    
    @IBOutlet weak var municiopioHeight: NSLayoutConstraint!
    @IBOutlet weak var bureoHeight: NSLayoutConstraint!
    
    
    var department = String()
    var municipio = String()
    var burrio  = String()
    
    var isdepindex = Int()
    var ismuniindex = Int ()
    var burrioindex = Int()
    var ResultArray  = NSArray()
    var departmentArray = NSArray()
    var  municialArray = NSArray()
    var burriosArray = NSArray()
    
    var section = String()
    var parentName = String()
    
    let selectedCollection = Int()
    
     @IBOutlet weak var departmentCollection: UICollectionView!
    @IBOutlet weak var municialCollection: UICollectionView!
    @IBOutlet weak var burriosCollection: UICollectionView!
    @IBOutlet weak var deptArrow: UIImageView!
    
    @IBOutlet weak var municialArrow: UIImageView!
    
    @IBOutlet weak var burrioArrow: UIImageView!
    
    @IBOutlet weak var buscarButton: UIButtonCustomClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isdepindex = -1;
        ismuniindex = -1;
        burrioindex = -1;

        
        
         self.getlistVc(parentName: "", section: "D")
    }
    
    
   
    @IBAction func sectionAction(_ sender: Any)
    {
        let button = sender as! UIButton
        if (button.isSelected == false)
        {
            button.isSelected = true
            self.getlistVc(parentName: "", section: "D")
            self.departmentCollection .reloadData()
            self.departmentHeightconstraint.constant = 180;
            departmentHeightconstraint.constant = departmentCollection.collectionViewLayout.collectionViewContentSize.height
            self.municiopioHeight.constant = 0;
            self.bureoHeight.constant = 0;
            self.deptArrow.image = #imageLiteral(resourceName: "down-arrow")
            self.municialArrow.image = #imageLiteral(resourceName: "rightarrow")
            self.burrioArrow.image = #imageLiteral(resourceName: "rightarrow")
            self.view.layoutIfNeeded()

        }
        else
        {
            self.deptArrow.image = #imageLiteral(resourceName: "rightarrow")
            self.municialArrow.image = #imageLiteral(resourceName: "rightarrow")
            self.burrioArrow.image = #imageLiteral(resourceName: "rightarrow")
            button.isSelected = false
            self.departmentHeightconstraint.constant = 0;
        }
        
        
    }
    
    @IBAction func tiendasSectonAction(_ sender: UIButton)
    {
       
         if (sender.tag == 1)
        {
            if (sender.isSelected == false)
            {
                if (department.count > 0)
                {
                    ResultArray = NSArray()
                    sender.isSelected = true
                    self.getlistVc(parentName: department, section: "M")
                    self.municialCollection .reloadData()
                    self.municiopioHeight.constant = 180;
                self.departmentHeightconstraint.constant = 0;
                    
            self.bureoHeight.constant = 0;
                    self.deptArrow.image = #imageLiteral(resourceName: "rightarrow")
                    self.municialArrow.image = #imageLiteral(resourceName: "down-arrow")
                    self.burrioArrow.image = #imageLiteral(resourceName: "rightarrow")

                    
            municiopioHeight.constant = municialCollection.collectionViewLayout.collectionViewContentSize.height
            self.view.layoutIfNeeded()
                }
               
            }
            else
            {
                self.deptArrow.image = #imageLiteral(resourceName: "rightarrow")
                self.municialArrow.image = #imageLiteral(resourceName: "rightarrow")
                self.burrioArrow.image = #imageLiteral(resourceName: "rightarrow")
                sender.isSelected = false
                self.municiopioHeight.constant = 0;
            }
           
        }
        else
        {
            if (sender.isSelected == false)
            {
            if (municipio.count > 0)
            {
              ResultArray = NSArray()
                    sender.isSelected = true
                    self.getlistVc(parentName: municipio, section: "B")
                self.burriosCollection.reloadData()
                self.deptArrow.image = #imageLiteral(resourceName: "rightarrow")
                self.municialArrow.image = #imageLiteral(resourceName: "rightarrow")
                self.burrioArrow.image = #imageLiteral(resourceName: "down-arrow")
                    self.bureoHeight.constant = 180;
                self.municiopioHeight.constant = 0;
                self.departmentHeightconstraint.constant = 0;
                    bureoHeight.constant = burriosCollection.collectionViewLayout.collectionViewContentSize.height
                    self.view.layoutIfNeeded()
                
                
            }
            }
            else
            {
                self.deptArrow.image = #imageLiteral(resourceName: "rightarrow")
                self.municialArrow.image = #imageLiteral(resourceName: "rightarrow")
                self.burrioArrow.image = #imageLiteral(resourceName: "rightarrow")
                sender.isSelected = false
                self.bureoHeight.constant = 0;
            }
            
            }
        
    }
    
    @IBAction func buscarAction(_ sender: Any)
    {
        Alomafire.sharedInstance.department = self.department
        Alomafire.sharedInstance.municipio = self.municipio
        Alomafire.sharedInstance.burrioString = self.burrio
        
        let Obj =  self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(Obj, animated: true)
        
    }
}
   
extension filterVc : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! TiendasCollectionViewCell
      
        if (collectionView.tag == 0)
        {
              cell.collectionTag.text = self.departmentArray.object(at: indexPath.row) as? String ?? "Data"
            if (isdepindex == indexPath.row)
            {
                department = self.departmentArray.object(at: indexPath.row) as? String ?? "Data"
                cell.cellbackView.backgroundColor = selectColor
            }
            else
            {
                cell.cellbackView.backgroundColor = UIColor.clear
            }
        }
        if (collectionView.tag == 1)
        {
              cell.collectionTag.text = self.ResultArray.object(at: indexPath.row) as? String ?? "Data"
            if (ismuniindex == indexPath.row)
            {
                municipio = self.ResultArray.object(at: indexPath.row) as? String ?? "Data"
                cell.cellbackView.backgroundColor = selectColor
            }
            else
            {
                cell.cellbackView.backgroundColor = UIColor.clear
            }
        }
        if (collectionView.tag == 2)
        {
              cell.collectionTag.text = self.ResultArray.object(at: indexPath.row) as? String ?? "Data"
            if (burrioindex == indexPath.row)
            {
                burrio = self.ResultArray.object(at: indexPath.row) as? String ?? "Data"
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
        
        if (collectionView.tag == 0)
        {
            
           return self.departmentArray.count
        }
        else
        {
       return ResultArray.count;
        }
//        else if (collectionView.tag == 1)
//        {
//            return self.municialArray.count
//        }
//        else
//        {
//            return self.burriosArray.count
//        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if (collectionView.tag == 0)
        {
            ismuniindex = -1;
            burrioindex = -1;
            self.department = departmentArray.object(at: indexPath.row) as? String ?? "Data"
            isdepindex = indexPath.row
            
        }
        if (collectionView.tag == 1 )
        {
            self.municipio = ResultArray.object(at: indexPath.row) as? String ?? "Data"
             burrioindex = -1;
            ismuniindex = indexPath.row
        }
        if (collectionView.tag == 2)
        {
            self.burrio = ResultArray.object(at: indexPath.row) as? String ?? "Data"
            burrioindex = indexPath.row
            
        }
        self .checkvalid()
        collectionView.reloadData()
        print("You selected cell #\(indexPath.item)!")
    }
}
extension filterVc
{
    func checkvalid()
    {
        let departmentTrimmed = self.department.trimmingCharacters(in: .whitespaces)
        let municipioTrimmed = self.municipio.trimmingCharacters(in: .whitespaces)
        let burrioStringTrimmed = self.burrio.trimmingCharacters(in: .whitespaces)
        
        if (departmentTrimmed.characters.count > 0 && municipioTrimmed.characters.count > 0 && burrioStringTrimmed.characters.count > 0 )
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
    
    
    func getlistVc(parentName : String , section : String)
    {
        
       
    if(applicationDelegate.isConnectedToNetwork == true)
        {
            self.view.endEditing(true)
            applicationDelegate .showActivityIndicatorView()
            
            var Urlstr = String ()
            Urlstr  = ServiceURL + "filterElement/?parentName=\(parentName)&section=\(section)"
            
           
            Urlstr = Urlstr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            Alomafire.sharedInstance.getservice(Urlstr: Urlstr)
            { (Result, error) in
                if ((error) != nil)
                {
                    applicationDelegate.hideActivityIndicatorView()
                    let errormessage = error? .localizedDescription
                    showAlert(self, message: errormessage!, title: appName)
                }
                if (error == nil)
                {
                    if Result?.value(forKey: "success") as! Int == 1
                    {
                        self.ResultArray = NSArray()
                    applicationDelegate .hideActivityIndicatorView()
                        
                        let result = Result?.value(forKey: "result") as! NSArray
                        
                        
                        if (section == "D")
                        {
                    self.departmentArray = result;
                  
                        }
                        else if (section == "M")
                        {
                            self.ResultArray = result;
                        self.municialArray = result;
                        self.municialCollection .reloadData()
                        self.municiopioHeight.constant = 180;
                        self.departmentHeightconstraint.constant = 0;
                        self.bureoHeight.constant = 0;
                        self.municiopioHeight.constant = self.municialCollection.collectionViewLayout.collectionViewContentSize.height
                        self.view.layoutIfNeeded()
                            
                        }
                        else if (section == "B")
                        {
                            self.ResultArray = result;
                        self.burriosArray = result;
                        self.burriosCollection .reloadData()
                            self.burriosCollection .reloadData()
                            self.bureoHeight.constant = 180;
                            self.municiopioHeight.constant = 0;
                        self.departmentHeightconstraint.constant = 0;
                            self.bureoHeight.constant = self.burriosCollection.collectionViewLayout.collectionViewContentSize.height
                            self.view.layoutIfNeeded()
                        }
                        
                    }
                    else
                    {
                        applicationDelegate .hideActivityIndicatorView()
                        
                        //self.refreshAfterloading()
                    }
                }
                else {
                    //                if (self.searchArray .count <= 0){
                    //                    self.noPhraseFound.isHidden = false}
                    
                }}
        }
        else
        {
            showAlert(self, message:connectivityMessage , title: appName)
        }
    }
    
    
}
