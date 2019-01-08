
import UIKit
import SDWebImage
class BannerVC: UIViewController {

    @IBOutlet weak var bannerecollectionView: UICollectionView!
    var resultArray = NSArray()
    var department = String()
    var municipio = String ()
    var barrio = String()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self .getlistVc()
    }
}

extension BannerVC  : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! TiendasCollectionViewCell
        let dict = resultArray.object(at:indexPath.row) as? NSDictionary
        let imgUrl = dict?.value(forKey:"imgUrl") as?  String
        let url = URL(string: imgUrl!)
        cell.bannerImg.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "logo"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return resultArray.count
    }
    //MARK:- UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
//        let dict = resultArray.object(at: indexPath.row) as? NSDictionary
//        let Obj =  self.storyboard?.instantiateViewController(withIdentifier: "BannerDetailVC") as! BannerDetailVC
//        Obj.link = dict?.value(forKey:"url") as?  String
//        self.navigationController?.pushViewController(Obj, animated: true)
//        print("You selected cell #\(indexPath.item)!")
    }
}

extension BannerVC
{
    func getlistVc()
    {
        if(applicationDelegate.isConnectedToNetwork == true)
        {
        self.view.endEditing(true)
        applicationDelegate .showActivityIndicatorView()
    var Urlstr : String = ServiceURL + "banner/?latitude=\(applicationDelegate.latitude)&longitude=\(applicationDelegate.longitude)"
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
                    applicationDelegate .hideActivityIndicatorView()
                    
                    let result = Result?.value(forKey: "result") as! NSArray
                    
                    self.resultArray = result ;
                    self.bannerecollectionView.reloadData()
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

